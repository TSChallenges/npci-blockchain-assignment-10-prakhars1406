PATH=${PWD}/../fabric-samples/bin:$PATH
FABRIC_CFG_PATH=$PWD/../fabric-samples/config/
CORE_PEER_TLS_ENABLED=true
CORE_PEER_LOCALMSPID="Cipla"
CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/users/Admin@Cipla.example.com/msp
CORE_PEER_ADDRESS=localhost:7051

echo "Register Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"RegisterDrug","Args":["AZD1001", "Paracetmol", "001", "07/04/2025","07/04/2027", "carbon and hydrogen"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'

echo "Ship Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"ShipDrug","Args":["AZD1001", "Medlife"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'

PATH=${PWD}/../fabric-samples/bin:$PATH
FABRIC_CFG_PATH=$PWD/../fabric-samples/config/
CORE_PEER_TLS_ENABLED=true
CORE_PEER_LOCALMSPID="Medlife"
CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/users/Admin@Medlife.example.com/msp
CORE_PEER_ADDRESS=localhost:9051

echo "Receive Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"ReceiverDrug","Args":["AZD1001"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'

echo "Ship Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"ShipDrug","Args":["AZD1001", "Apollo"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'

PATH=${PWD}/../fabric-samples/bin:$PATH
FABRIC_CFG_PATH=$PWD/../fabric-samples/config/
CORE_PEER_TLS_ENABLED=true
CORE_PEER_LOCALMSPID="Apollo"
CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/users/Admin@Apollo.example.com/msp
CORE_PEER_ADDRESS=localhost:13051

echo "Authenticate Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"VerifyAuthenticity","Args":["AZD1001"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'

PATH=${PWD}/../fabric-samples/bin:$PATH
FABRIC_CFG_PATH=$PWD/../fabric-samples/config/
CORE_PEER_TLS_ENABLED=true
CORE_PEER_LOCALMSPID="CDSCO"
CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/CDSCO.example.com/peers/peer0.CDSCO.example.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=$PWD/../fabric-samples/test-network/organizations/peerOrganizations/CDSCO.example.com/users/Admin@CDSCO.example.com/msp
CORE_PEER_ADDRESS=localhost:15051

echo "Audit Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"AddInspectionReport","Args":["AZD1001", "drug is correct"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'

echo "Recall Drug"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n drugChaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Cipla.example.com/peers/peer0.Cipla.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Medlife.example.com/peers/peer0.Medlife.example.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/../fabric-samples/test-network/organizations/peerOrganizations/Apollo.example.com/peers/peer0.Apollo.example.com/tls/ca.crt" -c '{"function":"RecallDrug","Args":["AZD1001", "drug is expired"]}'

sleep 2
echo "Query Drug"
peer chaincode query -C mychannel -n drugChaincode -c '{"Args":["TrackDrug", "AZD1001"]}'