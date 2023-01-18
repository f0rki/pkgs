#!/usr/bin/env python

import json
import sys
from collections import OrderedDict
from hashlib import sha3_224


def main():
    textidote_report = json.load(sys.stdin)
    findings = []

    for match in textidote_report['matches']:
        finding = OrderedDict({
            "type": "issue",
            "check_name": None,
            "description": None,
            "content": None,
            "categories": [],
            "fingerprint": None,
            "location": {
                "path": None,
                "lines": {
                    "begin": None,
                }
            }
        })

        finding['description'] = ("{}: {} - {}".format(
            match['rule']['issueType'], match['rule']['description'],
            match['message']))

        finding['categories'].append(match['rule']['category']['name'])

        finding['check_name'] = ("{}:{}".format(match['rule']['issueType'],
                                                match['rule']['id']))

        finding['content'] = {
            'body':
            f"""**{match['rule']}:**
{match['message']}

> {match['sentence']}
"""
        }

        # TODO: provide the location
        h = sha3_224()

        def hashit(d):
            for k, v in d.items():
                if v is None:
                    continue

                if isinstance(dict, v):
                    hashit(v)

                if isinstance(list, v):
                    for i in v:
                        hashit(i)

                if isinstance(str, v):
                    h.update(v.encode())
                # else ignore?

        hashit(finding)
        finding['fingerprint'] = h.hexdigest()
        findings.append(finding)

    json.dump(findings, sys.stdout)


if __name__ == "__main__":
    main()
