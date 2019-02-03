#!/bin/bash

[ -z $1 ] && echo "Usage: $0 <namespace> [days]" && exit 1

namespace=$1
days=${2:-182}

if [ ! -d pki ]; then
  echo "This script requires a directory named 'pki' in the current working directory, populated with a CA generated by easyrsa"
  exit 1
fi

docker run --user=$(id -u) -e EASYRSA_CRL_DAYS=$days -v $PWD:/etc/openvpn -ti ptlange/openvpn easyrsa gen-crl

kubectl delete configmap --namespace=$namespace openvpn-crl
kubectl create configmap --namespace=$namespace openvpn-crl --from-file=crl.pem=$PWD/pki/crl.pem
