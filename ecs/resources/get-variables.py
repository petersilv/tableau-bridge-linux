import os
import json
import argparse
import requests
import boto3

SESSION = boto3.session.Session()
CLIENT = SESSION.client(service_name='secretsmanager')


def main():
    args = parse_args()
    secret_name = args.secret
    task_id = get_task_id()
    
    # Get all variables from Secrets Manager and take available ones for this task
    all_variables = get_secret(secret_name)
    task_variables = get_available_token(all_variables)

    # Update the task_id for the assigned variables and write back to Secrets Manager
    updated_variables = update_variables(all_variables, task_variables, task_id)
    put_secret(secret_name, updated_variables)
    

def parse_args():
    parser = argparse.ArgumentParser(description='Get the Tableau Bridge variables from secrets manager')
    parser.add_argument('-s', '--secret', required=True, help='Specify the ID or name for the secret that you want to retrieve')
    args = parser.parse_args()
    return args


def get_secret(secret_name):
    try:
        response = CLIENT.get_secret_value(
            SecretId=secret_name
        )
    except CLIENT.exceptions.ResourceNotFoundException:
        raise Exception("Secrets Manager can't find the specified secret.")

    variables = json.loads(response['SecretString'])
    return variables


def get_task_id():
    endpoint = os.environ.get('ECS_CONTAINER_METADATA_URI_V4')
    response = requests.get(f"{endpoint}/task")
    task_id = response.json().get('TaskARN').split('/')[-1]
    return task_id


def get_available_token(all_variables):
    v_avaliable = [x for x in all_variables if not x['task_id']]

    if not v_avaliable:
        raise Exception("No available tokens found. Please check the varaibles in secrets manager.")

    variables = v_avaliable[0]

    with open('/variables', 'w') as file:
        for key, value in variables.items():
            file.write(f'{key}={value}\n')

    with open('/token', 'w') as file:
        file.write(json.dumps({variables['token_id']: variables['token_secret']}))

    return variables


def update_variables(all_variables, task_variables, task_id):
    for x in all_variables:
        if x['token_id'] == task_variables['token_id']:
            x['task_id'] = task_id
            break

    return all_variables


def put_secret(secret_name, updated_variables):
    response = CLIENT.put_secret_value(
        SecretId=secret_name,
        SecretString=json.dumps(updated_variables, indent=2)
    )
    return response


if __name__ == "__main__":
    main()
