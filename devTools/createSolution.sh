#!/bin/bash

# Check if a parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <folder_name>"
  exit 1
fi

# Define the project name variable
SOLUTION_NAME="lawyer.api.$1"
GIT_IGNORE_TEMPLATE="../lawyer.api.docker/devTools/gitignoreTemplate.txt"

# Leave current folder
cd ..

# Create the folder
mkdir -p "$SOLUTION_NAME"

# Navigate into the folder
cd "$SOLUTION_NAME" || exit

# Add git ignore
cp "$GIT_IGNORE_TEMPLATE" ./.gitignore

# Create solution
dotnet new sln -n "${SOLUTION_NAME}"

# Create the domain project
dotnet new classlib -n "${SOLUTION_NAME}.domain" -f net8.0
cd "${SOLUTION_NAME}.domain" || exit
dotnet add package FluentValidation --version 11.9.0
dotnet add package MediatR --version 12.2.0
dotnet add package ErrorOr --version 1.9.0
cd ..
echo "Project ${FOLDER_NAME}.domain created in $(pwd)"

# Create the application project
dotnet new classlib -n "${SOLUTION_NAME}.application" -f net8.0
cd "${SOLUTION_NAME}.application" || exit
dotnet add package AutoMapper --version 13.0.1
dotnet add package FluentValidation.DependencyInjectionExtensions --version 11.9.0
dotnet add package MediatR --version 12.2.0
dotnet add package Microsoft.Extensions.DependencyInjection.Abstractions --version 8.0.0
dotnet add package ErrorOr --version 1.9.0
cd ..
echo "Project ${FOLDER_NAME}.application created in $(pwd)"

# Create the infrastructure project
dotnet new classlib -n "${SOLUTION_NAME}.datastore.mssql" -f net8.0
cd "${SOLUTION_NAME}.datastore.mssql" || exit
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.2
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.2
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 8.0.2
dotnet add package Microsoft.Extensions.Configuration --version 8.0.0
dotnet add package Microsoft.Extensions.Options.ConfigurationExtensions --version 8.0.0
cd ..
echo "Project ${FOLDER_NAME}.datastore.mssql created in $(pwd)"

# Create the api project
dotnet new webapi -n "${SOLUTION_NAME}.webapi" -f net8.0
cd "${SOLUTION_NAME}.webapi" || exit
dotnet add package Microsoft.EntityFrameworkCore.Design --version 8.0.2
dotnet add package Swashbuckle.AspNetCore --version 6.5.0
dotnet add package Microsoft.AspNetCore.OpenApi --version 8.0.2
dotnet add package Serilog.AspNetCore --version 8.0.1
dotnet add package Serilog.Sinks.Console --version 5.0.1
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer --version 8.0.2
cd ..
echo "Project ${FOLDER_NAME}.webapi created in $(pwd)"

# Add projects to solution
dotnet sln add "${SOLUTION_NAME}.domain"/"${SOLUTION_NAME}.domain.csproj"
dotnet sln add "${SOLUTION_NAME}.application"/"${SOLUTION_NAME}.application.csproj"
dotnet sln add "${SOLUTION_NAME}.datastore.mssql"/"${SOLUTION_NAME}.datastore.mssql.csproj"
dotnet sln add "${SOLUTION_NAME}.webapi"/"${SOLUTION_NAME}.webapi.csproj"

# API project dependencies
dotnet add "${SOLUTION_NAME}.webapi"/"${SOLUTION_NAME}.webapi.csproj" reference "${SOLUTION_NAME}.application"/"${SOLUTION_NAME}.application.csproj"
dotnet add "${SOLUTION_NAME}.webapi"/"${SOLUTION_NAME}.webapi.csproj" reference "${SOLUTION_NAME}.datastore.mssql"/"${SOLUTION_NAME}.datastore.mssql.csproj"

# Application project dependencies
dotnet add "${SOLUTION_NAME}.application"/"${SOLUTION_NAME}.application.csproj" reference "${SOLUTION_NAME}.domain"/"${SOLUTION_NAME}.domain.csproj"

# Infrastructure project dependencies
dotnet add "${SOLUTION_NAME}.datastore.mssql"/"${SOLUTION_NAME}.datastore.mssql.csproj" reference "${SOLUTION_NAME}.application"/"${SOLUTION_NAME}.application.csproj"
dotnet add "${SOLUTION_NAME}.datastore.mssql"/"${SOLUTION_NAME}.datastore.mssql.csproj" reference "${SOLUTION_NAME}.domain"/"${SOLUTION_NAME}.domain.csproj"

#Init git
git init
git add .
git commit -m 'Initial commit'
