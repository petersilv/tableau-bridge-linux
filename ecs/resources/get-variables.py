import os
import json
import argparse
import requests
import boto3

# Parse command line arguments
parser = argparse.ArgumentParser(description='Get the Tableau Bridge variables from secrets manager')
parser.add_argument('-s', '--secret', required=True, help='Specify the ID or name for the secret that you want to retrieve')
args = parser.parse_args()

# Set up the Secrets Manager client
session = boto3.session.Session()
client = session.client(service_name='secretsmanager')

# Get the id for the current running task
endpoint = os.environ.get('ECS_CONTAINER_METADATA_URI_V4')
response = requests.get(f"{endpoint}/task")
task_id = response.json().get('TaskARN').split('/')[-1]

# Get all variables from secrets manager
get_secret_value_response = client.get_secret_value(
    SecretId=args.secret
)

v_all = json.loads(get_secret_value_response['SecretString'])

# Filter to only the variables that aren't being used by other clients
v = [x for x in v_all if not x['task_id']][0]

# Write out the environment variables & token file
with open('/variables', 'w') as file:
    for key, value in v.items():
        file.write(f'{key}={value}\n')

with open('/token', 'w') as file:
    file.write(json.dumps({v['token_id']: v['token_secret']}))

# Update the task_id for the assigned token and write back to secrets manager
for x in v_all:
    if x['token_id'] == v['token_id']:
        x['task_id'] = task_id
        break

put_secret_value_response = client.put_secret_value(
    SecretId=args.secret,
    SecretString=json.dumps(v_all, indent=2)
)
