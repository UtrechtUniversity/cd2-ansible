# CD2 platform

# HOW TO SETUP


# Using ansible playbook for the deployment of the CD2-catalog  
Purpose of the ansible script is to deploy the CD2-platform conform the Utrecht University ITS-standards of deployment.  
The customized CKAN-based portal accompanied by an OAI-PMH-service allowing  for harvesting the catalog (in datacite format only).


To be able to do so, the ansible script deploys 3 software modules as developed by Utrecht University.  
These modules are being maintained within Github.

For the CD2-portal following repo's are required:

**cd2-ckan-theme** (https://github.com/UtrechtUniversity/cd2-ckan-theme).   
Mainly contains the CD2-catalog's look & feel for the frontend application with CKAN as a base.


**cd2-config**  (https://github.com/UtrechtUniversity/cd2-config).  
Mainly contains configurational items for the catalog to able to work properly.  
Think of the required CKAN and SOLR schema's for this particular application.


In order to add the OAI-PMH-service following repo is required:  
**ckanext-oaipmh-server** (https://github.com/UtrechtUniversity/ckanext-oaipmh-server).



# Step 1: Check following configuration items first!
Before running the ansible playbook please check whether the correct branches or commits have been set for each github-repo.  
In the playbook file:

**cd2-ansible/roles/ckan/defaults/main.yml**

check for  and maybe adjust following entries and verify whether the correct/latest versions, branches or commits have been taken into account:

```
# CKAN extension versions - these are merely examples so please check the latest!
ckan_cd2_theme_version: 2873b614385444d1cb6b39425c201493049596ca  # Version of 6 February 2024

ckan_cd2_config_version: aab2057e56705c0e57639f1aac6d3af36e71011a # Version of 6 February 2024

ckan_oaipmh_server_plugin_version: ab5144024cac361bfaa1d355a34920d26296f7bd # Version of 7 March 2024
```

# Step 2: Run ansible playbook
Actual running of ansible is described here:

 https://github.com/UtrechtUniversity/cd2-ansible/blob/development-its/README.md


# Step 3: Configure CD2-CKAN-catalog
After completion of the playbook the CD2-CKAN-catalog is up&running.  
However, it is still an empty shell.
In order to be able to add data to the catalog following steps have to be taken first:


- Add administrator user(s)  
  Do this by logging in as the initial administrator (created by Ansible) via CKAN-URL /user/login

Administrator users are required as they need to perform the following steps:

  - Add organizations/studies  
In this case the name of a study/organization is of importance due to the fact that the loader (external data loading application depends on these)
[youth, trails, l-cid, radar, gen-r, ntr] only!

  - Generate API key  
The API key is required for external access through the CD2-CKAN-API. This enables adding/updating datapackages and organizations


# Step 4: Publication of research data to the CD2-catalog and DataCite
The CD2-catalog, together with DataCite, are used as an integral publication platform for individual development data.  
This requires data to be both published to the CD2-CKAN-catalog as well as DataCite; on top of that DataCite-publications will use the corresponding CD2-package publications as landingpages.


## Data taxonomy loader application
The data taxonomy loader application manages publication of datapackages/measures (https://github.com/UtrechtUniversity/cd2-taxonomy).  
The loader application performs data preparation tasks required before the actual publication to  
- CD2-catalog
- DataCite

Each CD2-datapackage published in DataCite gets its own DOI.  
Each CD2-datapackage in DataCite has a landing page pointing to the datapackage within the CD2-catalog based on its CKAN identifier.

## Step 4.1 Publication to DataCite
In order to be able to publish to DataCite the following configuration has to be taken into account:  

**Development/Testing purposes:**  
Datacite Website: https://doi.test.datacite.org  
API endpoint: https://api.test.datacite.org/  
Credentials as handed out by DataCite  
Prefix: 10.80154  
 
 
**Production environment:**  
Datacite Website https://doi.datacite.org  
API endpoint:  https://api.datacite.org/dois/  
Credentials as handed out by DataCite  
Prefix: 10.60641  


## Step 4.2 Publication to the CD2-catalog
Publication to the CD2_catalog requires CKAN-API-access and the loader needs to be configured as such.
This is described within the application code itself.  

The API-key itself has already been created in a previous step.

After loading data, the CD2 platform is ready for use.
