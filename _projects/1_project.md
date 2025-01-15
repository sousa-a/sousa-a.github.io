---
layout: post
title: "Data preparation"
description: "Data aquisition, preprocessing/cleaning and ETL"
author: "Alessandro O de Sousa"
tags: [Data cleaning, ETL, SQL, Pandas, Numpy, Seaborn, Matplotblib, Plotly, Power BI]
img: /assets/img/medicines.jpg
importance: 1
category: Case Study - YellowLynx MedCorp (fictional)
toc:
  sidebar: left
---

<hr>

# Case Study: Analysis of medicine usage in an integrated hospital network (YellowLynx MedCorp) - Part 1 - Data collection and preprocessing/cleaning.
<br>
This project consists of a fictional scenario in which a health-related enterprize, YellowLynx MedCorp, needs to closely monitor inventory and stock usage, particularly medicines, across its various hospital departments located in a metropolitan area.<br>

In this first section, I will focus on the data collection, preprocessing/cleaning aspects of the project.

## 1. Business problem
YellowLynx MedCorp is a fast-paced growing healthcare company that has closed on the acquisition of two more hospitals. Each hospital had its own enterprise resource planning (ERP) used to manage stock and purchases.<br>

Also, the nomenclature used for each product is slightly different from hospital to hospital. That is also the case for department's names.<br>

YellowLynx MedCorp need to closely monitor inventory and medicine usage in a timely manner using metrics for managerial use in a integrated hospital network.

It is necessary to standartize and integrate the information coming from these various sources.

## 2. Objectives

1. To demonstrate end-to-end capability in understanding business problems and proposing solutions, always using an analytical mindset and attention to detail.<br>

2. To demonstrate proficiency in relational databases, SQL language and Python for data cleaning/preparation, analysis, and insights.<br>

3. To demonstrate the ability to integrate and summarize the acquired knowledge in reports, executive summaries, and dashboards that provide relevant information related to inventory management and financial expenditures information to the executive team in a timely and reliable manner.<br><br>

Despite being a personal case study, the reports were written using the third person plural, as if it were a team effort.<br><br>
**Disclaimer:** The data used in this case study is completely fictional, entirely created by the author and used for educational purposes only. No data was not collected from any existing databases elsewhere.<br><br>

### Final product

The final product comprises a 4 page Power BI report embed bellow.

<iframe title="hospitals" width="850" height="490" src="https://app.powerbi.com/view?r=eyJrIjoiNDJhZGVkZjUtZDI1ZS00NDc5LThkODUtMGYwNDU2OGRhYmZiIiwidCI6IjE2MTMyNTk2LWExMzgtNGM4NS1hYTViLTY0ZDk5YTJlY2U4NyJ9" frameborder="0" allowFullScreen="true"></iframe>

<br><br>

## 3. Data collection, cleaning and Exploratory Data Analysis (EDA) process
The dataset has a primary source, it was provided by the IT department of the company in a zip file containing 5 csv files detailing the stock movement/usage from the pharmacy of each hospital from 2020 to 2023.
Each hospital name was replaced by an acronym that describes the size and specialization. There were 3 large-size general hospitals and 2 medium-size specialized hospitals.<br><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* LGH1: Large-size General Hospital 1<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* LGH2: Large-size General Hospital 2<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* LGH3: Large-size General Hospital 3<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* MSH1: Medium-size Specialized Hospital 1<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* MSH2: Medium-size Specialized Hospital 2<br><br>

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os, sys
import random
import string
```
<br>
### 1.1 Data loading
The provided csv files were loaded into dataframes in a Jupyter Notebook using Python 3.10.9.<br>

At first glance, it was possible to observe a high variability in the number of features/attributes and nomenclatures for both medicines and department names across different hospitals.<br>

After an extensive cleaning process, the dataframes were combined into the *hospitals_df* dataframe.<br>

This dataset comprises all stock movement/usage history from the pharmacy to each hospital department. It is shown bellow a brief description of each feature found in the cleaned *hospitals_df* dataframe.<br>

Each row consists of a stock movement of a product/medicine.<br><br>


<caption><b>Table 1. Features of the hospitals_df dataframe.</b></caption>

| Index | Feature Name | Pandas data type | Description                                                                                                                                                                                                                                                                                                                          |
|-----------|------------------|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0         | SenderLocationID | object               | An acronym that identifies each hospital<br>- LGH1: Large-size General Hospital 1<br>- LGH2: Large-size General Hospital 2<br>- LGH3: Large-size General Hospital 3<br>- MSH1: Medium-size Specialized Hospital 1<br>- MSH2: Medium-size Specialized Hospital 2<br>The hospital’s pharmacy is the medicine supplier for all departments. |
| 1         | OrderID          | object               | An unique random 12-digit alphanumeric sequence that identifies a specific order by a hospital department.                                                                                                                                                                                                                               |
| 2         | Date             | datetime64[ns]       | Specifies the date in which the order was completed.                                                                                                                                                                                                                                                                                     |
| 3         | ReceiverID       | object               | Consists of the ID the department that receives the medicines for each order.                                                                                                                                                                                                                                                            |
| 4         | ReceiverName     | object               | Consists of the name the department that receives the medicines for each order.                                                                                                                                                                                                                                                          |
| 5         | InOut            | object               | Indicates if the stock movement is “in” or “out”.                                                                                                                                                                                                                                                                                        |
| 6         | MovementType     | object               | Indicates the type of movement. It can be a “Request”, a “Restock”, an “Adjustment”,<br>a “Disposal of expired product” or “Damaged product”.                                                                                                                                                                                            |
| 7         | SKU              | object               | Stock Keeping Unit (SKU), consists of a unique random 5-digit numeric sequence that<br>identifies a product/medicine                                                                                                                                                                                                                     |
| 8         | Product          | object               | The name of the product/medicine.                                                                                                                                                                                                                                                                                                        |
| 9         | ClassID          | object               | An unique identifier related to the pharmacological class of the medicine.                                                                                                                                                                                                                                                               |
| 10        | ClassName        | object               | The name of the pharmacological class.                                                                                                                                                                                                                                                                                                   |
| 11        | MeasurementUnit  | object               | The measurement unit of the medicine.                                                                                                                                                                                                                                                                                                    |
| 12        | StandartPrice    | float64              | The unit price value.                                                                                                                                                                                                                                                                                                                    |
| 13        | Quantity         | float64              | The quantity of units transferred in the order.                                                                                                                                                                                                                                                                                          |
| 14        | RemainingStock   | float64              | The remaining stock of the product/medicine in the hospital pharmacy.                                                                                                                                                                                                                                                                    |
| 15        | StockValue       | float64              | The monetary value obtained by the product between the order’s medicine standard price”<br>and the quantify transferred.                                                                                                                                                                                                                 |

<br>

### 1.2 Column dropping
In each dataframe, irrelevant variables were dropped and the dataframes merged into a single one.
<br><br>

### 1.3 Dataframe structure check
Back in the Jupyter notebook, list comprehensions were used to ensure that dataframes have the same structure and variable/column names.<br>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dataframe structure check</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>

<body>
<details>
    <summary><b>Click to expand/collapse code</b></summary>
    <pre class="line-numbers"><code class="language-python">#Load CSV into dataframes
LGH1_fact = pd.read_csv('/Users/alessandro/yellowlynx/primarysource/lgh1.csv',
                        sep='\t', parse_dates=['date','date_modified'])
LGH2_fact = pd.read_csv('/Users/alessandro/yellowlynx/primarysource/lgh2.csv',
                        sep='\t', parse_dates=['date','date_modified'])
LGH3_fact = pd.read_csv('/Users/alessandro/yellowlynx/primarysource/lgh3.csv',
                        sep='\t', parse_dates=['date','date_modified'])
MSH1_fact = pd.read_csv('/Users/alessandro/yellowlynx/primarysource/msh1.csv',
                        sep='\t', parse_dates=['date','date_modified'])
MSH2_fact = pd.read_csv('/Users/alessandro/yellowlynx/primarysource/msh2.csv',
                        sep='\t', parse_dates=['date','date_modified'])

#Drop specific columns
LGH1_fact.drop(columns=['summary', 'date_modified', 'image' 'weight'])
LGH2_fact.drop(columns=['summary', 'tags', 'date_modified'])
LGH3_fact.drop(columns=['Column7', 'date_modified', 'weight'])
MSH1_fact.drop(columns=['tags', 'date_modified',])
MSH2_fact.drop(columns=['summary', 'tags', 'date_modified'])

#Creates a name index for each hospital and a list for the list comprehensions bellow for data validity check
hospital_list = ['LGH1', 'LGH2', 'LGH3', 'MSH1', 'MSH2']
hospitals_data = [LGH1_fact, LGH2_fact, LGH3_fact, MSH1_fact, MSH2_fact]

hospitals_data_shape = pd.DataFrame([x.shape for x in hospitals_data], columns = ['n_rows','n_columns'], index=hospital_list)
hospitals_data_shape.reset_index(inplace=True)
hospitals_data_shape = hospitals_data_shape.rename(columns={'index':'hospital'})

hospitals_data_dtypes = pd.DataFrame([np.dtype(hospitals_data[0]) for x in hospitals_data])

hospitals_data_columns = pd.DataFrame([x.columns for x in hospitals_data], index=hospital_list)
hospitals_data_columns.reset_index(inplace=True)
hospitals_data_columns = hospitals_data_columns.rename(columns={'index':'hospital'})
hospitals_shape_columns = hospitals_data_shape.merge(hospitals_data_columns, how='inner', on='hospital')</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/prism.min.js"></script> <script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script> <script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>

</body>
</html><br>

### 1.4 Nomenclature standardization
Numpy arrays containing unique entries for each variable were created and exported to individual csv files.<br> Extensive analyses conducted in Microsoft Excel allowed the construction of several dictionaries produced to standardize nomenclatures and to allow further transformations<br><br>


### 1.5 Data anonymization
Although this is a fictional dataset, we used the random module to generate alphanumeric sequences in order to replace a patient name list created previously using the Faker package (https://faker.readthedocs.io/).<br>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>

<body>
<details>
    <summary><b>Click to expand/collapse code</b></summary>
    <pre class="line-numbers"><code class="language-python">#Merge dataframes and exports it to a csv
directory = '/Users/alessandro/yellowlynx/'
hospitals_df = pd.DataFrame()
for filename in os.listdir(directory):
    if filename.endswith('.csv'):
        df = pd.read_csv(os.path.join(directory, filename))
        master_df = master_df.append(df, ignore_index=True)
hospitals_df.to_csv('/Users/alessandro/yellowlynx/hospitals_df.csv', index=False)

#Create unique values numpy arrays created for each variable and exported to csv files.
ClassID = hospitals_df['ClassID'].unique()
OrderID = hospitals_df['OrderID'].unique()
GroupDescriptionNames = hospitals_df['ClassName'].unique()
MeasurementUnit = hospitals_df['MeasurementUnit'].unique()
Sku = hospitals_df['SKU'].unique()
MedNames = hospitals_df['Product'].unique()
ReceiverNameUnique = hospitals_df['ReceiverName'][hospitals_df['MovementType']!='Dispensing'].unique()
FakePatientsList = hospitals_df['ReceiverName'][hospitals_df['MovementType']=='Dispensing'].unique()

pd.DataFrame(ClassID.tolist()).to_csv('/Users/alessandro/yellowlynx/ClassID.csv', index=False)
pd.DataFrame(OrderID.tolist()).to_csv('/Users/alessandro/yellowlynx/OrderID.csv', index=False)
pd.DataFrame(GroupDescriptionNames.tolist()).to_csv('/Users/alessandro/yellowlynx/groupDescNames.csv', index=False)
pd.DataFrame(MeasurementUnit.tolist()).to_csv('/Users/alessandro/yellowlynx/MeasurementUnit.csv', index=False)
pd.DataFrame(Sku.tolist()).to_csv('/Users/alessandro/yellowlynx/Sku.csv', index=False)
pd.DataFrame(MedNames.tolist()).to_csv('/Users/alessandro/yellowlynx/MedNames.csv', index=False)
pd.DataFrame(ReceiverNameUnique.tolist()).to_csv('/Users/alessandro/yellowlynx/ReceiverNameUnique.csv', index=False)
pd.DataFrame(FakePatientsList.tolist()).to_csv('/Users/alessandro/yellowlynx/FakePatientsList.csv', index=False)

#Create randomic integer or alphanumeric sequences for anonymization.
ClassIDRandomInts = [random.randint(100,999) for i in ClassID]
SkuRandomInts = [random.randint(1000,9999) for i in Sku]
ReceiverIDRandomInts = [random.randint(10000,99999) for i in ReceiverNameUnique]
OrderIDRandom = [''.join((random.choices(string.ascii_letters + string.digits,k=12))) for i in OrderID]
PatientsRandom = [''.join((random.choices(string.ascii_letters + string.digits,k=12))) for i in FakePatientsList]
pd.DataFrame(ClassIDRandomInts).to_csv('/Users/alessandro/yellowlynx/GroupIDRandomInts.csv', index=False)
pd.DataFrame(SkuRandomInts).to_csv('/Users/alessandro/yellowlynx/SkuRandomInts.csv', index=False)
pd.DataFrame(OrderIDRandom).to_csv('/Users/alessandro/yellowlynx/OrderIDRandom.csv', index=False)
pd.DataFrame(PatientsRandom).to_csv('/Users/alessandro/yellowlynx/PacientsRandom.csv', index=False)
pd.DataFrame(ReceiverIDRandomInts).to_csv('/Users/alessandro/yellowlynx/ReceiverIDRandomInts.csv', index=False)

#Create dictionaries to standardize nomenclature and perform correspondent replacements in each variable.
#Only a section of each dictionary is shown bellow.
dictSenderLocationID = {'Red Cross Hospital':'MSH2', 'West Bridge Hospital':'LGH3', 'Park Avenue Hosp':'LGH2', 'OrthoClinic':'MSH1', "Children's Hospital":'LGH1'}
dictOrderID = {'RCH014908':'0_QVTG2Q3R1MAY','RCH020827':'1904_IXYBBWHWA5G5','RCH018761':'1904_J3IF74GESI9J','RCH023155':'2000_T9QXHFMSNZXL','RCH025991':'2000_E2IMCUS7TOEA','RCH017042':'2000_YEBJKDDLRC0J','RCH43372':'2000_2LMTJZGRLMB2', ...}
dictClassID = {'09A02A':'601','09A02B':'728','09A03A':'541','09A03B':'328','09A03F':'510','09A04A':'837','09A05A':'778','09A06A':'138','09A07A':'938','09A07C':'837','09A10A':'828','09A10B':'353','09A11A':'484','09A11D':'435', ...}
dictMeasurementUnit = {'AMP ':'AMP','BS ':'TUBE','CJ ':'SET','CP ':'TBT','CS ':'CPS','DG ':'DRG','EN ':'ENV','FA ':'ABT','FR ':'BT','GL ':'GL','GR ':'GR','KT ':'SET','ML ':'ML','PT ':'PT','TB ':'TB','UM ':'UN','UN ':'UN'}
dictSku = {'0':'0','604':'5347','607':'9171','612':'3876','654':'6365','666':'4819','694':'8847','695':'9466','708':'8598','1038':'6451','2198':'2815','2280':'2327','2988':'6086','3243':'3493','3286':'3411','4350':'5764', ...}
dictGroupDesc = {' ALQUILANTES':'ALKYLATING AGENTS',' ANTIADRENÉRGICOS CENTRAIS':'ANTIADRENERGIC AGENTS, CENTRALLY ACTING',' ANTICOLINÉRGICOS':'ANTICHOLINERGICS AGENTS',' ANTIINFLAMATÓRIOS':'ANTI-INFLAMMATORY DRUGS', ...}
dictMedNames = {'ACICLOVIR 250 MG':'ACICLOVIR (SODIUM) 250 MG INJECTION, POWDER, FOR SOLUTION','ACICLOVIR 200 MG':'ACICLOVIR 200 MG TABLET','ACICLOVIR POMADA 0,03 G/G BISNAGA 4,5 G':'ACICLOVIR 0,03 G/G 4,5 G OINTMENT,OPHTHALMIC', ...}
dictReceiverName = {'Wonka Industries':'SUPPLIER','Acme Corp.':'SUPPLIER','Stark Industries':'SUPPLIER','internal_medicine_inpatient':'LGH2_INPATIENT_INTERNAL_MEDICINE',"Ollivander's Wand Shop":'SUPPLIER','Internal_Medicine_Inpatient':'LGH2_INPATIENT_INTERNAL_MEDICINE', ...}
dictReceiverID = {'LGH1_ADMINISTRATION':'26631','LGH1_ANESTHETICS':'18494','LGH1_CARDIOLOGY_OUTPATIENT':'19874','LGH1_CENTRAL_STERILE_SERVICES':'46371','LGH1_DIAGNOSTIC_IMAGING':'95463','LGH1_DIAGNOSTIC_LABORATORY':'70358', ...}

#Map columns according to dictionaries.
hospitals_df['SenderLocationID'] = hospitals_df['SenderLocationID'].map(dictSenderLocationID)
hospitals_df['OrderID'] = hospitals_df['OrderID'].map(dictOrderID)
hospitals_df['ClassID'] = hospitals_df['ClassID'].map(dictClassID)
hospitals_df['MeasurementUnit'] = hospitals_df['MeasurementUnit'].map(dictMeasurementUnit)
hospitals_df['SKU'] = hospitals_df['SKU'].map(dictSku)
hospitals_df['ClassName'] = hospitals_df['ClassName'].map(dictGroupDesc)
hospitals_df['Product'] = hospitals_df['Product'].map(dictMedNames)
hospitals_df['ReceiverName'] = hospitals_df['ReceiverName'].map(dictReceiverName)
hospitals_df['ReceiverID'] = hospitals_df['ReceiverName'].map(dictReceiverID)</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/prism.min.js"></script> <script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script> <script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>

</html><br>

### 1.6 Initial data analyses
This cleaned dataframe *hospitals_df* contains 16 columns and 1,797,173 rows.
In addition to the extensive cleaning process, there were no missing values or duplicates.<br>

```python
hospitals_df.shape
```
(1797173, 16)<br><br>

```python
hospitals_df.info()
```
<caption><b>Table 2. Output of hospitals_df.info().</b></caption>

|  | Column       | Dtype      |
|----------|------------------|----------------|
| 0        | SenderLocationID | object         |
| 1        | OrderID          | object         |
| 2        | Date             | datetime64[ns] |
| 3        | ReceiverID       | object         |
| 4        | ReceiverName     | object         |
| 5        | InOut            | object         |
| 6        | MovementType     | object         |
| 7        | SKU              | object         |
| 8        | Product          | object         |
| 9        | ClassID          | object         |
| 10       | ClassName        | object         |
| 11       | MeasurementUnit  | object         |
| 12       | StandartPrice    | float64        |
| 13       | Quantity         | float64        |
| 14       | RemainingStock   | float64        |
| 15       | StockValue       | float64        |

<br>

```python
hospitals_df.head(5)
```
<caption><b>Table 3. Output of hospitals_df.head().</b></caption>

|   | SenderLocationID |      OrderID      |    Date    |   ReceiverID  |  ReceiverName | InOut | MovementType |  SKU |                      Product                      | ClassID |                     ClassName                     | MeasurementUnit | StandartPrice | Quantity | RemainingStock | StockValue |
|:-:|:----------------:|:-----------------:|:----------:|:-------------:|:-------------:|:-----:|:------------:|:----:|:-------------------------------------------------:|:-------:|:-------------------------------------------------:|:---------------:|:-------------:|:--------:|:--------------:|:----------:|
| 0 | MSH2             | 0590_QVTG2Q3R1MAY | 2020-04-20 | MSH2_PHARMACY | MSH2_PHARMACY | Out   | Request      | 5347 | BUDESONIDE 32MCG/ACTUATION 120 ACTUATIONS AERO... | 295     | OTHER DRUGS FOR UPPER AIRWAY OBSTRUCTION, INHA... | BT              | 7.571365      | -1.0     | 0.0            | 7.571365   |
| 1 | MSH2             | 1904_IXYBBWHWA5G5 | 2020-05-13 |               | SUPPLIER      | In    | Restock      | 5347 | BUDESONIDE 32MCG/ACTUATION 120 ACTUATIONS AERO... | 295     | OTHER DRUGS FOR UPPER AIRWAY OBSTRUCTION, INHA... | BT              | 7.570198      | 2.0      | 2.0            | 15.140395  |
| 2 | MSH2             | 1904_J3IF74GESI9J | 2020-05-14 | MSH2_PHARMACY | MSH2_PHARMACY | Out   | Request      | 5347 | BUDESONIDE 32MCG/ACTUATION 120 ACTUATIONS AERO... | 295     | OTHER DRUGS FOR UPPER AIRWAY OBSTRUCTION, INHA... | BT              | 7.570198      | -1.0     | 1.0            | 7.570198   |
| 3 | MSH2             | 2000_T9QXHFMSNZXL | 2020-06-08 | MSH2_PHARMACY | MSH2_PHARMACY | Out   | Request      | 5347 | BUDESONIDE 32MCG/ACTUATION 120 ACTUATIONS AERO... | 295     | OTHER DRUGS FOR UPPER AIRWAY OBSTRUCTION, INHA... | BT              | 7.570198      | -1.0     | 0.0            | 7.570198   |
| 4 | MSH2             | 2000_E2IMCUS7TOEA | 2020-06-08 |               | SUPPLIER      | In    | Restock      | 5347 | BUDESONIDE 32MCG/ACTUATION 120 ACTUATIONS AERO... | 295     | OTHER DRUGS FOR UPPER AIRWAY OBSTRUCTION, INHA... | BT              | 7.570198      | 2.0      | 2.0            | 15.140395  |

<br>

```python
hospitals_df.isna().sum()
```
<caption><b>Table 4. Output of hospitals_df.isna().sum().</b></caption>

| Feature          | Sum |
|------------------|-----|
| SenderLocationID | 0   |
| OrderID          | 0   |
| Date             | 0   |
| ReceiverID       | 0   |
| ReceiverName     | 0   |
| InOut            | 0   |
| MovementType     | 0   |
| SKU              | 0   |
| Product          | 0   |
| ClassID          | 0   |
| ClassName        | 0   |
| MeasurementUnit  | 0   |
| StandartPrice    | 0   |
| Quantity         | 0   |
| RemainingStock   | 0   |
| StockValue       | 0   |
| dtype: int64     |     |

<br>

```python
hospitals_df.duplicated().sum()
```
0<br><br>

### 1.6.1 New columns/ feature engineering
A new variable was created to assign a stock value for each row in the dataset.<br>
Year, month and quarter columns where also added.<br>
Additional features were designed later on.

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>

<body>
<details>
    <summary><b>Click to expand/collapse code</b></summary>
    <pre class="line-numbers"><code class="language-python">#Create a month column
hospitals_df['month'] = hospitals_df['Date'].dt.month.apply(lambda x: f'{x:02d}')

#Create a year column
hospitals_df['year'] = hospitals_df['Date'].dt.year

#Create a year_month column
hospitals_df['year_month'] = hospitals_df['Date'].dt.strftime('%Y-%m')

#Create a quarter column
hospitals_df['quarter'] = hospitals_df['Date'].dt.quarter

#Create a year-quarter column
hospitals_df['year_quarter'] = pd.PeriodIndex(hospitals_df['Date'], freq='Q')

#Create a column referencing the stock value of every ocurrence.
hospitals_df['StockValue'] = abs(hospitals_df['StandartPrice']*hospitals_df['Quantity'])</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

Thats it for now!

In the [second section](/projects/2_project/), I will focus on the **exploratory data analysis (EDA)** and **data visualization**.

<hr>
