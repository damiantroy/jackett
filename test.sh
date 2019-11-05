#!/usr/bin/env bash
set -x

curl http://127.0.0.1:9117/torznab/all/api |grep 'error code="100"'
RESULT=$?

if [[ ${RESULT} -eq 0 ]]; then
    echo "* Test successful"
else
    echo "* Test failed!"
fi

exit ${RESULT}

