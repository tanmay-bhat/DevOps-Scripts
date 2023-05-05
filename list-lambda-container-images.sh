#Shell script to print the lambda images that uses container images.
#Usage example: list-lambda-container-images.sh --profile staging --region us-west-2


#!/bin/bash

set +xeu

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -p|--profile) profile="$2"; shift ;;
    -r|--region) region="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done


profile="${profile:-$AWS_PROFILE}"
region="${region:-$AWS_DEFAULT_REGION}"

if [[ -z "${profile}" || -z "${region}" ]]; then
  echo "Warning: Profile and/or region arguments are not passed. Using default values from environment variables."
fi

functions=$(aws --profile $profile --region $region lambda list-functions --query 'Functions[*].[FunctionName]' --output text)

if [ -z "$functions" ]; then
  echo "No functions found in region $region"
  exit 1
fi

data=()

for function in $functions; do
  image=$(aws --profile $profile --region $region lambda get-function --function-name $function --query 'Code.ImageUri' --output text)
  if [ "$image" != "None" ]; then
    data+=("$function" "$image")
  elif [ -z "$image" ]; then
    echo "None of the functions are using container images in region $region"
    exit 1
  fi
done

if [ ${#data[@]} -gt 0 ]; then
  printf "%-50s %-50s\n" "Function Name" "Image URI"
  printf "%-50s %-50s\n" "-------------" "---------"
  printf "%-50s %-50s\n" "${data[@]}" | column -t -s $'\t'
fi
