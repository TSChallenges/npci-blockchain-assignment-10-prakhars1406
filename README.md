# NPCI-Blockchain-Assignment-10
## Pharmaceutical Supply Chain [10 Marks]

## Overview
This assignment focuses on implementing a blockchain-based drug traceability and compliance system using **Hyperledger Fabric**. The goal is to ensure **transparency, authenticity, and regulatory compliance** in the pharmaceutical supply chain.

## Objectives
By completing this assignment, you will:
- Set up a **Hyperledger Fabric network** with multiple pharmaceutical stakeholders.
- Develop **chaincode** for drug registration, shipment, handover, and recall.
- Implement **role-based access control** for manufacturers, distributors, pharmacies, and regulators.
- Interact with the ledger using **CLI and SDK tools** to simulate a drug's lifecycle.

## Prerequisites
- GitHub Account (for code submission)
- Docker & Docker Compose installed
- **Go Programming Knowledge** (for chaincode development)
- Familiarity with **Hyperledger Fabric** (channels, peers, chaincode)
- Access to `fabric-samples` repository

## Steps to Follow

- This GitHub repository will be accessible to you once you accept the Assignment.
- You have to work directly in this GitHub repository. It is like your own copy of the original repository.
- You can use GitHub Codespace, or your own system to work on the Assignment. 
- To start a new Codespace, select `Code` dropdown >> `Create Codespace on main`. It will have Docker and Go language preinstalled.

**Note:** 
- It may take few minutes for the Codespace to start after you click on "Create Codespace on main".
- Use **Hyperledger Fabric v2.5.10** in GitHub Codespace for your implementation.
- Use the below commands to install Fabric samples, Docker images, and binaries:

  **Get the install script:**
    
  `curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh`

  **Run the script:**
    
  `./install-fabric.sh --fabric-version 2.5.10`


## Assignment Tasks
### 1. Set Up Hyperledger Fabric Network [2 Marks]
Customize the **test-network** sample to configure a network with the following organizations:
- **Cipla** (Manufacturer)
- **Medlife** (Distributor)
- **Apollo** (Pharmacy)
- **CDSCO** (Regulator - India's central drug authority)
- **OrdererOrg** (Orderer organization with a single orderer node)

Each organization must have:
- One **peer node**
- **MSP configuration** and admin identity

### 2. Implement Chaincode for Drug Lifecycle Management [3 Marks]
Develop a **Go chaincode (`drugChaincode.go`)** supporting the following operations:
#### 📦 Drug Production
- `RegisterDrug` - Manufacturer registers a drug batch (ID, name, mfg date, expiry date, composition, etc.)

#### 🚚 Drug Movement
- `ShipDrug` - Shipment of drugs between organizations
- `ReceiveDrug` - Confirmation of drug receipt

#### 🧾 Drug Traceability
- `TrackDrug` - Trace current location and history of a drug
- `VerifyAuthenticity` - Verify if a drug is genuine
- `RecallDrug` - Regulator recalls a batch

#### 🔒 Compliance
- `GetAuditLog` - Regulator fetches transaction history
- `AddInspectionReport` - Regulator logs inspections

#### Sample Drug Object Model
```go
 type Drug struct {
     DrugID          string   `json:"drugId"`
     Name            string   `json:"name"`
     Manufacturer    string   `json:"manufacturer"`
     BatchNumber     string   `json:"batchNumber"`
     MfgDate         string   `json:"mfgDate"`
     ExpiryDate      string   `json:"expiryDate"`
     Composition     string   `json:"composition"`
     CurrentOwner    string   `json:"currentOwner"`
     Status         string   `json:"status"`
     History       []string  `json:"history"`
     IsRecalled     bool     `json:"isRecalled"`
     InspectionNotes []string `json:"inspectionNotes"`
 }
```

### 3. Deploy and Test [3 Marks]
Deploy the network and install `drugChaincode.go` on all peers. Test the following scenario:
1. Cipla registers drug batch `AZD1001`
2. Cipla ships it to **Medlife**
3. Medlife receives it and ships it to **Apollo**
4. Apollo verifies authenticity of `AZD1001`
5. CDSCO performs an audit and recalls `AZD1001` due to safety concerns

### 4. Query & Validate Ledger [2 Marks]
Use `peer chaincode query` and SDK-based scripts to:
- Track **drug location**
- Verify **ownership transitions**
- Confirm **batch recalls**
- Display **inspection/audit history**

Ensure:
- Only manufacturers can register drugs.
- Only regulators can recall drugs or add inspection notes.
- Traceability is verifiable and tamper-proof.


## Deliverables
Upload a **GitHub repo** containing:
- Customized **Fabric network setup scripts**
- Chaincode file (`drugChaincode.go`)
- Test scripts (`invoke.sh`, `query.sh`)
- **Screenshots/logs** demonstrating:
  - Network deployment
  - Successful **drug registration, shipment, traceability, and recall**
  - Ledger queries and access control validation

## Additional Notes
- Use event listeners for shipment, recall, and inspection events.
- Enable TLS and set up identities properly for MSPs..
- Use CouchDB as the state database for rich queries (optional but recommended).
- Debug using Docker logs (`docker logs peer0.cipla.example.com`).

---

**Happy coding!** 🚀


