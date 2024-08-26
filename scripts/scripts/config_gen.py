#!/usr/bin/env python3
import yaml

with open('.github/config.yaml', 'r') as file:
    data = yaml.safe_load(file)

for key in data:
    for sub_key, items in data[key].items():
        output_env = f".github/.env.{key}.{sub_key}"
        with open(output_env, 'w') as outfile:
            for item in items.items():
                formatted_key = item[0].upper()
                outfile.write(f'{formatted_key}="{item[1]}"\n')

        print(f"Environment variables for {key} saved to {output_env}")