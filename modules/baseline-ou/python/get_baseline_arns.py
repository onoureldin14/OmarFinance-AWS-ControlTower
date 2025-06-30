#!/usr/bin/env python3

import subprocess
import json
import os

def run_cli(cmd):
    env = os.environ.copy()
    env["AWS_PROFILE"] = "default"
    return subprocess.check_output(cmd, shell=True, env=env).decode("utf-8").strip()

# Get AWSControlTowerBaseline ARN
baseline_arn = run_cli(
    "aws controltower list-baselines --query \"baselines[?name=='AWSControlTowerBaseline'].arn\" --output text"
)

# Try to get IdentityCenterBaseline ARN
try:
    idc_baseline_arn = run_cli(
        "aws controltower list-baselines --query \"baselines[?name=='IdentityCenterBaseline'].arn\" --output text"
    )


    idc_enabled_arn = run_cli(
        f"aws controltower list-enabled-baselines --query \"enabledBaselines[?baselineIdentifier=='{idc_baseline_arn}'].arn\" --output text"
    )
except subprocess.CalledProcessError:
    idc_enabled_arn = ""

output = {
    "ct_baseline_arn": baseline_arn,
    "idc_baseline_arn": idc_enabled_arn or ""
}

print(json.dumps(output))
