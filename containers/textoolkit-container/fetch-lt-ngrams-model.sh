#!/usr/bin/env bash

export _LM_URL=${LM_URL:-"https://languagetool.org/download/ngram-data"}

set -e

function cleanup() {
  rm /opt/languagemodel/*.zip || true
}
trap cleanup EXIT

mkdir -p /opt/languagemodel || true
cd /opt/languagemodel
set -x 
wget -q "$_LM_URL/ngrams-en-20150817.zip"
unzip ngrams-en-20150817.zip 
wget -q "$_LM_URL/ngrams-de-20150819.zip"
unzip ngrams-de-20150819.zip

cleanup
