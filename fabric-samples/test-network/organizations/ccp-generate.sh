#!/usr/bin/env bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/Cipla.example.com/tlsca/tlsca.Cipla.example.com-cert.pem
CAPEM=organizations/peerOrganizations/Cipla.example.com/ca/ca.Cipla.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Cipla.example.com/connection-Cipla.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Cipla.example.com/connection-Cipla.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/Medlife.example.com/tlsca/tlsca.Medlife.example.com-cert.pem
CAPEM=organizations/peerOrganizations/Medlife.example.com/ca/ca.Medlife.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Medlife.example.com/connection-Medlife.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Medlife.example.com/connection-Medlife.yaml

ORG=4
P0PORT=13051
CAPORT=13054
PEERPEM=organizations/peerOrganizations/Apollo.example.com/tlsca/tlsca.Apollo.example.com-cert.pem
CAPEM=organizations/peerOrganizations/Apollo.example.com/ca/ca.Apollo.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Apollo.example.com/connection-Apollo.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Apollo.example.com/connection-Apollo.yaml

ORG=5
P0PORT=15051
CAPORT=15054
PEERPEM=organizations/peerOrganizations/CDSCO.example.com/tlsca/tlsca.CDSCO.example.com-cert.pem
CAPEM=organizations/peerOrganizations/CDSCO.example.com/ca/ca.CDSCO.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/CDSCO.example.com/connection-CDSCO.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/CDSCO.example.com/connection-CDSCO.yaml
