package chaincode

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/v2/contractapi"
)

type Drug struct {
	DrugID          string   `json:"drugId"`
	Name            string   `json:"name"`
	Manufacturer    string   `json:"manufacturer"`
	BatchNumber     string   `json:"batchNumber"`
	MfgDate         string   `json:"mfgDate"`
	ExpiryDate      string   `json:"expiryDate"`
	Composition     string   `json:"composition"`
	CurrentOwner    string   `json:"currentOwner"` // Cipla, Medlife, Apollo
	Status          string   `json:"status"`       // InProduction, InTransit, Delivered, Recalled
	History         []string `json:"history"`      // Format: "timestamp|event|from|to|details"
	IsRecalled      bool     `json:"isRecalled"`
	InspectionNotes []string `json:"inspectionNotes"`
}

type SmartContract struct {
	contractapi.Contract
}

// ============== MANUFACTURER FUNCTIONS ==============
func (s *SmartContract) RegisterDrug(ctx contractapi.TransactionContextInterface,
	drugID string, name string, batchNumber string, mfgDate string, expiryDate string, composition string) error {

	var mspID string
	var err error

	if mspID, err = ctx.GetClientIdentity().GetMSPID(); err != nil {
		return fmt.Errorf("unable to read mspID for drug registration")
	}

	if mspID != "Cipla" {
		return fmt.Errorf("only Cipla can register drugs")
	}

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing != nil {
		return fmt.Errorf("drug with %s already exists", drugID)
	}

	drug := Drug{
		DrugID:       drugID,
		Name:         name,
		Manufacturer: "Cipla",
		BatchNumber:  batchNumber,
		MfgDate:      mfgDate,
		ExpiryDate:   expiryDate,
		Composition:  composition,
		CurrentOwner: "Cipla",
		Status:       "InProduction",
		History:      []string{fmt.Sprintf("%s|%s|%s", mfgDate, "Cipla", "InProduction")},
		IsRecalled:   false,
	}

	drugJSON, err := json.Marshal(drug)
	if err != nil {
		return err
	}

	if err := ctx.GetStub().PutState(drugID, drugJSON); err != nil {
		return fmt.Errorf("unable to put drug data on ledgers")
	}

	return ctx.GetStub().SetEvent("shipDrug", drugJSON)
}

// ============== DISTRIBUTION FUNCTIONS ==============
func (s *SmartContract) ShipDrug(ctx contractapi.TransactionContextInterface, drugID string, to string) error {

	var mspID string
	var drugData []byte
	var err error

	if mspID, err = ctx.GetClientIdentity().GetMSPID(); err != nil {
		return fmt.Errorf("unable to read mspID for drug distribution")
	}

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing == nil {
		return fmt.Errorf("drug with %s dosen't exists", drugID)
	}

	var drug Drug
	if err := json.Unmarshal(existing, &drug); err != nil {
		return fmt.Errorf("unable to unmarshal drug details")
	}

	if mspID != drug.CurrentOwner {
		return fmt.Errorf("only current owner can ship the drug")
	}

	drug.Status = "InTransit"
	drug.CurrentOwner = to
	drug.History = append(drug.History, fmt.Sprintf("%s|%s|%s", drug.CurrentOwner, to, "InTransit"))

	if drugData, err = json.Marshal(drug); err != nil {
		return fmt.Errorf("unable to marshal drug data")
	}

	if err := ctx.GetStub().PutState(drugID, drugData); err != nil {
		return fmt.Errorf("unable to put drug data on ledger")
	}

	return ctx.GetStub().SetEvent("shipDrug", drugData)
}

func (s *SmartContract) ReceiverDrug(ctx contractapi.TransactionContextInterface, drugID string) error {

	var mspID string
	var drugData []byte
	var err error

	if mspID, err = ctx.GetClientIdentity().GetMSPID(); err != nil {
		return fmt.Errorf("unable to read mspID for drug")
	}

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing == nil {
		return fmt.Errorf("drug with %s dosen't exists", drugID)
	}

	var drug Drug
	if err := json.Unmarshal(existing, &drug); err != nil {
		return fmt.Errorf("unable to unmarshal drug details")
	}

	if mspID != drug.CurrentOwner {
		return fmt.Errorf("only current owner can receive the drug")
	}

	drug.Status = "Delivered"
	drug.History = append(drug.History, fmt.Sprintf("%s|%s", drug.CurrentOwner, "Delivered"))

	if drugData, err = json.Marshal(drug); err != nil {
		return fmt.Errorf("unable to marshal drug data")
	}

	if err := ctx.GetStub().PutState(drugID, drugData); err != nil {
		return fmt.Errorf("unable to put drug data on ledger")
	}

	return ctx.GetStub().SetEvent("receivedDrug", drugData)
}

// ============== REGULATOR FUNCTIONS ==============
func (s *SmartContract) RecallDrug(ctx contractapi.TransactionContextInterface, drugID string, reason string) error {
	var mspID string
	var drugData []byte
	var err error

	if mspID, err = ctx.GetClientIdentity().GetMSPID(); err != nil {
		return fmt.Errorf("unable to read mspID for drug distribution")
	}

	if mspID != "CDSCO" {
		return fmt.Errorf("only CDSCO can Recall drugs")
	}

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing == nil {
		return fmt.Errorf("drug with %s dosen't exists", drugID)
	}

	var drug Drug
	if err := json.Unmarshal(existing, &drug); err != nil {
		return fmt.Errorf("unable to unmarshal drug details")
	}

	drug.Status = "Recalled"
	drug.IsRecalled = true
	drug.InspectionNotes = append(drug.InspectionNotes, reason)
	drug.History = append(drug.History, fmt.Sprintf("%s|%s|%s", "CDSCO", "Recalled", reason))

	if drugData, err = json.Marshal(drug); err != nil {
		return fmt.Errorf("unable to marshal drug data")
	}

	if err := ctx.GetStub().PutState(drugID, drugData); err != nil {
		return fmt.Errorf("unable to put drug data on ledger")
	}

	return ctx.GetStub().SetEvent("recallDrug", drugData)
}

// ============== COMMON FUNCTIONS ==============
func (s *SmartContract) TrackDrug(ctx contractapi.TransactionContextInterface, drugID string) ([]string, error) {

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing == nil {
		return nil, fmt.Errorf("drug with %s dosen't exists", drugID)
	}

	var drug Drug
	if err := json.Unmarshal(existing, &drug); err != nil {
		return nil, fmt.Errorf("unable to unmarshal drug details")
	}

	return drug.History, nil
}

func (s *SmartContract) VerifyAuthenticity(ctx contractapi.TransactionContextInterface, drugID string) (bool, error) {

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing == nil {
		return false, fmt.Errorf("drug with %s dosen't exists", drugID)
	}

	var drug Drug
	if err := json.Unmarshal(existing, &drug); err != nil {
		return false, fmt.Errorf("unable to unmarshal drug details")
	}

	if drug.Manufacturer != "Cipla" || drug.ExpiryDate >= time.Now().GoString() {
		return false, fmt.Errorf("unable to authenticate drug")
	}

	return true, nil
}

func (s *SmartContract) AddInspectionReport(ctx contractapi.TransactionContextInterface, drugID string, report string) error {

	var mspID string
	var err error

	if mspID, err = ctx.GetClientIdentity().GetMSPID(); err != nil {
		return fmt.Errorf("unable to read mspID for drug distribution")
	}

	if mspID != "CDSCO" {
		return fmt.Errorf("only CDSCO can add inspection report for drugs")
	}

	existing, err := ctx.GetStub().GetState(drugID)
	if err == nil && existing == nil {
		return fmt.Errorf("drug with %s dosen't exists", drugID)
	}

	var drug Drug
	if err := json.Unmarshal(existing, &drug); err != nil {
		return fmt.Errorf("unable to unmarshal drug details")
	}

	drug.InspectionNotes = append(drug.InspectionNotes, report)

	var drugData []byte
	if drugData, err = json.Marshal(drug); err != nil {
		return fmt.Errorf("unable to marshal drug data")
	}

	if err := ctx.GetStub().PutState(drugID, drugData); err != nil {
		return fmt.Errorf("unable to put drug data on ledger")
	}

	return ctx.GetStub().SetEvent("addedInspectionReport", drugData)
}

func (s *SmartContract) GetAuditLog(ctx contractapi.TransactionContextInterface, drugID string) (*[]Drug, error) {

	var records = []Drug{
		{
			DrugID: "",
		},
	}
	resultsIterator, err := ctx.GetStub().GetHistoryForKey(drugID)
	if err != nil {
		return &records, err
	}
	defer resultsIterator.Close()

	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return &records, err
		}

		var asset Drug
		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &asset)
			if err != nil {
				return &records, err
			}
		} else {
			asset = Drug{
				DrugID: drugID,
			}
		}
		records = append(records, asset)
	}
	return &records, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(&SmartContract{})
	if err != nil {
		fmt.Printf("Error creating chaincode: %s", err.Error())
		return
	}
	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincode: %s", err.Error())
	}
}
