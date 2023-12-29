---
layout: post
title: "YellowLynx MedCorp. Pt1"
description: "Exploratory Data Analysis and PowerBi reports"
author: "Alessandro O de Sousa"
tags: [EDA, SQL, Python, PowerBI]
img: /assets/img/medicines.jpg
importance: 1
category: work
---

<hr>

# Case Study: Analysis of medicine usage in an integrated hospital network (YellowLynx MedCorp) - Part 1.
This project consists of a fictional scenario in which a health-related enterprize, YellowLynx MedCorp, needs to closely monitor inventory and stock usage, particularly medicines, across its various hospital departments located in a metropolitan area.

## Business problem
YellowLynx MedCorp is a fast-paced growing healthcare company that has closed on the acquisition of two more hospitals. Each hospital had its own enterprise resource planning (ERP) used to manage stock and purchases.<br>

Also, the nomenclature used for each product is slightly different from hospital to hospital. That is also the case for department's names.<br>

YellowLynx MedCorp need to closely monitor inventory and medicine usage in a timely manner using metrics for managerial use in a integrated hospital network.
It is necessary to standartize and integrate the information coming from these various sources.

## Objectives:
1. To demonstrate end-to-end capability in understanding business problems and proposing solutions, always using an analytical mindset and attention to detail.<br>

2. To demonstrate proficiency in relational databases, SQL language and Python for data cleaning/preparation, analysis, and insights.<br>

3. To demonstrate the ability to integrate and summarize the acquired knowledge in reports, executive summaries, and dashboards that provide relevant information related to inventory management and financial expenditures information to the executive team in a timely and reliable manner.<br><br>

Despite being a personal case study, the reports were written using the third person plural, as if it were a team effort.<br><br>
**Disclaimer:** The data used in this case study is completely fictional, entirely created by the author and used for educational purposes only. No data was not collected from any existing databases elsewhere.<br><br>

## Final product snapshots

The final product comprises 4 PowerBI reports decipted bellow.

{% include figure.html path="/assets/img/figure1_powerbireports.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 1. Final product snapshots.</div>
<br>

## 1. Data collection, cleaning and Exploratory Data Analysis (EDA) process
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

### 1.1 Data loading
The provided csv files were loaded into dataframes in a Jupyter Notebook using Python 3.10.9.<br>

At first glance, it was possible to observe a high variability in the number of features/attributes and nomenclatures for both medicines and department names across different hospitals.<br>

After an extensive cleaning process, the dataframes were combined into the *hospitals_df* dataframe.<br>

This dataset comprises all stock movement/usage history from the pharmacy to each hospital department. It is shown bellow a brief description of each feature found in the cleaned *hospitals_df* dataframe.<br>

Each row consists of a stock movement of a product/medicine.<br>

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

### 1.6 Data analyses
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

### 1.6.2 List of Medicines
We wanted to discover the sets of medicines that are used in each hospital as well as the used exclusively in each hospital.
A list of medicines was used for the hospitals as well as the classes each medicine belonged.
Theses lists were used to create a dataframe summarizing the data.

#### Insights:<br>

* There is a total of 480 different medicines listed in the present dataset and only 187 (38,9%) of them are used in all hospitals.<br><br>
* Of the 480 medicines, 32 are used exclusively in LGH2.<br><br>
* There is a wide range of unit prices for the medicines in this dataset, from $0.01 to $6593.10.<br><br>
* The max unit price of the medicines used in MSH1 and MSH2 is considerably lower than the ones observed for LGH1, LGH2 and LGH.<br><br>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">#Create sets of unique products used in each hospital.
LGH1_product_set = set(hospitals_df['Product'].loc[hospitals_df['SenderLocationID'] == 'LGH1'])
LGH2_product_set = set(hospitals_df['Product'].loc[hospitals_df['SenderLocationID'] == 'LGH2'])
LGH3_product_set = set(hospitals_df['Product'].loc[hospitals_df['SenderLocationID'] == 'LGH3'])
MSH1_product_set = set(hospitals_df['Product'].loc[hospitals_df['SenderLocationID'] == 'MSH1'])
MSH2_product_set = set(hospitals_df['Product'].loc[hospitals_df['SenderLocationID'] == 'MSH2'])

#Set of unique medicines used in all 5 hospitals.
hospitals_product_set = len(set(hospitals_df['Product']))

#Create sets of unique medicine classes used in each hospital.
LGH1_class_set = set(hospitals_df['ClassName'].loc[hospitals_df['SenderLocationID'] == 'LGH1'])
LGH2_class_set = set(hospitals_df['ClassName'].loc[hospitals_df['SenderLocationID'] == 'LGH2'])
LGH3_class_set = set(hospitals_df['ClassName'].loc[hospitals_df['SenderLocationID'] == 'LGH3'])
MSH1_class_set = set(hospitals_df['ClassName'].loc[hospitals_df['SenderLocationID'] == 'MSH1'])
MSH2_class_set = set(hospitals_df['ClassName'].loc[hospitals_df['SenderLocationID'] == 'MSH2'])

#Create a set of unique products used in all 5 hospitals.
Product_set_all_hospitals = (LGH1_product_set & LGH2_product_set & LGH3_product_set & MSH1_product_set & MSH2_product_set)

#Create sets of unique products used exclusively in each hospital.
LGH1_only_product_set = (LGH1_product_set - LGH2_product_set - LGH3_product_set - MSH1_product_set - MSH2_product_set)
LGH2_only_product_set = (LGH2_product_set - LGH1_product_set - LGH3_product_set - MSH1_product_set - MSH2_product_set)
LGH3_only_product_set = (LGH3_product_set - LGH1_product_set - LGH2_product_set - MSH1_product_set - MSH2_product_set)
MSH1_only_product_set = (MSH1_product_set - LGH1_product_set - LGH2_product_set - LGH3_product_set - MSH2_product_set)
MSH2_only_product_set = (MSH2_product_set - LGH1_product_set - LGH2_product_set - LGH3_product_set - MSH1_product_set)

#Transform the above created sets into lists.
LGH1_only_product_list = sorted([x for x in LGH1_only_product_set])
LGH2_only_product_list = sorted([x for x in LGH2_only_product_set])
LGH3_only_product_list = sorted([x for x in LGH3_only_product_set])
MSH1_only_product_list = sorted([x for x in MSH1_only_product_set])
MSH2_only_product_list = sorted([x for x in MSH2_only_product_set])

#Number of hospital departments.
lgh1_n_departments = set(hospitals_df['ReceiverName'].loc[
    (hospitals_df['SenderLocationID'] == 'LGH1') &
    (hospitals_df['ReceiverName'] != 'SUPPLIER') &
    (hospitals_df['ReceiverName'].str.contains('LGH1')) &
    (~hospitals_df['ReceiverName'].str.contains('PHARMACY', na=False))])

lgh2_n_departments = set(hospitals_df['ReceiverName'].loc[
    (hospitals_df['SenderLocationID'] == 'LGH2') &
    (hospitals_df['ReceiverName'] != 'SUPPLIER') &
    (hospitals_df['ReceiverName'].str.contains('LGH2')) &
    (~hospitals_df['ReceiverName'].str.contains('PHARMACY', na=False))])

lgh3_n_departments = set(hospitals_df['ReceiverName'].loc[
    (hospitals_df['SenderLocationID'] == 'LGH3') &
    (hospitals_df['ReceiverName'] != 'SUPPLIER') &
    (hospitals_df['ReceiverName'].str.contains('LGH3')) &
    (~hospitals_df['ReceiverName'].str.contains('PHARMACY', na=False))])

msh1_n_departments = set(hospitals_df['ReceiverName'].loc[
    (hospitals_df['SenderLocationID'] == 'MSH1') &
    (hospitals_df['ReceiverName'] != 'SUPPLIER') &
    (hospitals_df['ReceiverName'].str.contains('MSH1')) &
    (~hospitals_df['ReceiverName'].str.contains('PHARMACY', na=False))])

msh2_n_departments = set(hospitals_df['ReceiverName'].loc[
    (hospitals_df['SenderLocationID'] == 'MSH2') &
    (hospitals_df['ReceiverName'] != 'SUPPLIER') &
    (hospitals_df['ReceiverName'].str.contains('MSH2')) &
    (~hospitals_df['ReceiverName'].str.contains('PHARMACY', na=False))])

#Create function that define the min, max and average of the medicines unit price.
def min_price(df,hospital):
    return "{:.2f}".format(df['StandartPrice'].loc[(df['SenderLocationID']==hospital) & (df['StandartPrice']>0)].min())
def max_price (df,hospital):
    return "{:.2f}".format(df['StandartPrice'].loc[df['SenderLocationID']==hospital].max())
def avg_price(df,hospital):
    return "{:.2f}".format(np.array(list(set(df['StandartPrice'].loc[df['SenderLocationID']==hospital]))).mean())

#Average number of medicines used by department.
lgh1_mean_med_n = hospitals_df.loc[hospitals_df['SenderLocationID']=='LGH1']


print("Total Number of medicines: ", hospitals_product_set,
      "\nTotal Number of medicines used in all hospitals: ", len(Product_set_all_hospitals))

#Create a dataframe that describes the length of each set.
medicines_df = pd.DataFrame(data= {
  'Hospital Name':                    ['LGH1','LGH2','LGH3','MSH1','MSH2'],
  'Medicines used in the hospital':   [
                                        len(LGH1_product_set),
                                        len(LGH2_product_set),
                                        len(LGH3_product_set),
                                        len(MSH1_product_set),
                                        len(MSH2_product_set)
                                      ],
  'Medicines exclusively used':       [
                                        len(LGH1_only_product_set),
                                        len(LGH2_only_product_set),
                                        len(LGH3_only_product_set),
                                        len(MSH1_only_product_set),
                                        len(MSH2_only_product_set)
                                      ],
  'N.º of medicine classes':          [
                                        len(LGH1_class_set),
                                        len(LGH2_class_set),
                                        len(LGH3_class_set),
                                        len(MSH1_class_set),
                                        len(MSH2_class_set)
                                      ],
  'N.º of departments':               [
                                        len(lgh1_n_departments),
                                        len(lgh2_n_departments),
                                        len(lgh3_n_departments),
                                        len(msh1_n_departments),
                                        len(msh2_n_departments)
                                      ],
  'Medicines unit price min ($)':     [
                                        min_price(hospitals_df,'LGH1'),
                                        min_price(hospitals_df,'LGH2'),
                                        min_price(hospitals_df,'LGH3'),
                                        min_price(hospitals_df,'MSH1'),
                                        min_price(hospitals_df,'MSH2')
                                      ],
  'Medicines unit price max ($)': 
                                      [
                                        max_price(hospitals_df,'LGH1'),
                                        max_price(hospitals_df,'LGH2'),
                                        max_price(hospitals_df,'LGH3'),
                                        max_price(hospitals_df,'MSH1'),
                                        max_price(hospitals_df,'MSH2')
                                      ],

  'Medicines unit price average ($)': [
                                        avg_price(hospitals_df,'LGH1'),
                                        avg_price(hospitals_df,'LGH2'),
                                        avg_price(hospitals_df,'LGH3'),
                                        avg_price(hospitals_df,'MSH1'),
                                        avg_price(hospitals_df,'MSH2')
                                      ]
                                  })
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

* Total Number of medicines:  480<br><br>
* Total Number of medicines used in all hospitals:  187<br><br>

<caption><b>Table 5. Quantity of medicines used in each hospital.</b></caption>

|   | Hospital Name | Medicines used in the hospital | Medicines exclusively used | N.º of medicine classes | N.º of departments | Medicines unit price min ($) | Medicines unit price max ($) | Medicines unit price average ($) |
|:-:|:-------------:|:------------------------------:|:--------------------------:|:-----------------------:|:------------------:|:----------------------------:|:----------------------------:|:--------------------------------:|
| 0 | LGH1          | 424                            | 2                          | 123                     | 36                 | 0.01                         | 6593.10                      | 34.50                            |
| 1 | LGH2          | 459                            | 32                         | 126                     | 47                 | 0.01                         | 6593.10                      | 41.49                            |
| 2 | LGH3          | 418                            | 2                          | 121                     | 38                 | 0.01                         | 6593.10                      | 37.31                            |
| 3 | MSH1          | 226                            | 6                          | 94                      | 10                 | 0.01                         | 76.28                        | 2.74                             |
| 4 | MSH2          | 290                            | 2                          | 96                      | 15                 | 0.01                         | 499.20                       | 6.03                             |

<br>

### 1.6.3 Total Stock Usage (TSU)
We also wanted to evaluate the total stock usage averages ($) across hospitals by quarter as well as the monthly and daily averages by quarter.<br>
A *Tsu* class and methods were created to evaluate each aggregate values. The concept of Total Stock Usage (TSU) was used in the analyses to follow.<br>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">class Tsu():
    
    #Filter conditions
    base_conditions = ((hospitals_df['InOut'] == 'Out') &
                       (hospitals_df['ReceiverName'] != 'SUPPLIER') &
                       (~hospitals_df['ReceiverName'].str.contains('PHARMACY', na=False)))
   
    def __init__(self,df,hospital):
        self.df = df
        self.hospital = hospital
        
    def month_sum(self,year,month):
        '''Calculates the total stock usage (TSU) by month.'''
        return "{:.2f}".format(df['StockValue'].loc[(
                                        self.base_conditions &
                                        (df['SenderLocationID'] == self.hospital) &
                                        (df['year'] == year) &
                                        (df['quarter'] == month) &
                                        (df['ReceiverName'].str.contains(self.hospital)))].sum())
    
    def quarter_sum(self,year,quarter):
        '''Calculates the total stock usage (TSU) by quarter.'''
        df = self.df
        return "{:.2f}".format(df['StockValue'].loc[(
                                        self.base_conditions &
                                        (df['SenderLocationID'] == self.hospital) &
                                        (df['year'] == year) &
                                        (df['quarter'] == quarter) &
                                        (df['ReceiverName'].str.contains(self.hospital)))].sum())
    
    def year_avg_df(self,year):
        '''Calculates the total stock usage (TSU) by year and returns a dataframe.'''
        df = self.df
        return df.loc[(
                       self.base_conditions &
                       (df['SenderLocationID'] == self.hospital) &
                       (df['year'] == year) &
                       (df['ReceiverName'].str.contains(self.hospital)))].mean()

    def monthly_avg_quarter(self,year,quarter):
        '''Calculates the total stock usage (TSU) monthly average.'''
        return (df.loc[self.base_conditions &
                                  (df['SenderLocationID'] == self.hospital) &
                                  (df['year'] == year) &
                                  (df['quarter'] == quarter) &
                                  (df['ReceiverName'].str.contains(self.hospital))
                                  ].groupby(['month','SenderLocationID'])['StockValue'].sum()).mean()
    
    def monthly_avg_year(self,year):
        '''Calculates the total stock usage (TSU) monthly average.'''
        df = df.loc[self.base_conditions &
                     (df['SenderLocationID'] == self.hospital) &
                     (df['year'] == year) &
                     (df['ReceiverName'].str.contains(self.hospital))
                     ].groupby(['month','SenderLocationID'])['StockValue'].sum().mean()

    def daily_avg_quarter(self,year,quarter):
        '''Calculates the total stock usage (TSU) daily average.'''
        return (df.loc[self.base_conditions &
                                  (df['SenderLocationID'] == self.hospital) &
                                  (df['year'] == year) &
                                  (df['quarter'] == quarter) &
                                  (df['ReceiverName'].str.contains(self.hospital))
                                  ].groupby(['Date','SenderLocationID'])['StockValue'].sum()).mean()
  
    def month_sum_df(self):
        '''Returns a dataframe describing the total stock usage TSU by month, absolute and percentage
        changes from previous month and cumulative TSU'''
        df = self.df.loc[(self.base_conditions &
                     (self.df['SenderLocationID'] == self.hospital) &
                     (self.df['ReceiverName'].str.contains(self.hospital))
                     )].pivot_table(index='year_month',
                           values='StockValue',
                           aggfunc='sum').reset_index().rename(columns={'year_month':'Year-month','StockValue':'TSU'})
        df['SenderLocationID'] = self.hospital
        df['Year'] = df['Year-month'].str[0:4].astype(int)
        df['Month'] = df['Year-month'].str[5:]
        df['Change from previous month'] = df['TSU'] - df['TSU'].shift(1)
        df['Percentage Change from last month'] = ((df['TSU'] / df['TSU'].shift(1)) -1)*100
        df['Cumulative Sum by year'] = pd.concat([
                                                  pd.Series(df['TSU'].loc[df['Year-month'].str.contains('2020')].cumsum()),
                                                  pd.Series(df['TSU'].loc[df['Year-month'].str.contains('2021')].cumsum()),
                                                  pd.Series(df['TSU'].loc[df['Year-month'].str.contains('2022')].cumsum()),
                                                  pd.Series(df['TSU'].loc[df['Year-month'].str.contains('2023')].cumsum())])
        
        yearly_avg = df.groupby('Year')['TSU'].mean()
        df = df.merge(yearly_avg.rename('Yearly TSU average'), left_on='Year', right_index=True)
        df['Deviation from yearly TSU average'] = df['TSU'] - df['Yearly TSU average']
        df['Normalized (mean) deviation from the mean'] = (df['Deviation from yearly TSU average'] - (df['Deviation from yearly TSU average'].mean())
                                                           )/(max(df['Deviation from yearly TSU average']) - min(df['Deviation from yearly TSU average']))
        df.fillna(0, inplace=True)
        return df
    
    def monthly_avg_quarter_df(self):
        '''Returns a dataframe describing total stock usage (TSU) monthly average by quarter.'''
        df = ((self.df.loc[self.base_conditions &
                           (self.df['SenderLocationID'] == self.hospital) &
                           (self.df['ReceiverName'].str.contains(self.hospital))
                           ].groupby('year_quarter')['StockValue'].sum())/3).reset_index().drop(columns='year_quarter').rename(columns={'StockValue':f'{self.hospital} - TSU monthly average '}).squeeze()
        return df
    
    def quarter_sum_by_dept_df(self,year,quarter):
        '''Returns a dataframe describing total stock usage (TSU) by quarter grouped by hospital department.'''
        df = self.df
        df = df.loc[(hospitals_df['SenderLocationID'] == self.hospital) &
                     (df['year'] == year) &
                     (df['quarter'] == quarter) &
                     (df['InOut'] == 'Out') &
                     (df['ReceiverName'] != 'SUPPLIER') &
                     (df['ReceiverName'].str.contains(self.hospital)) &
                     (~df['ReceiverName'].str.contains('PHARMACY', na=False))
                     ].groupby(['ReceiverName'])['StockValue'].sum().reset_index().sort_values(by = ['StockValue'], ascending=False)
        df['ReceiverName'] = df['ReceiverName'].str[5:]
        df['ReceiverName'] = df['ReceiverName'].str.replace("_", " ")
        return df
    
    
    def month_sum_by_medicine_df(self, year):
        '''Returns a dataframe describing total stock usage (TSU) by medicine by month. It also includes the 
        Total Stock Usage mean (TSU), the deaviation from the yearly TSU mean and a normalized deviation for
        each medicine in each year'''
        #Silence the PerformanceWarning (PW) in pandas
        from warnings import simplefilter
        simplefilter(action="ignore", category=pd.errors.PerformanceWarning)

        df = self.df
        df_pivot = df.loc[(self.base_conditions &
                        (df['SenderLocationID'] == self.hospital) &
                        (df['ReceiverName'].str.contains(self.hospital)))]
        
        #Pivot the DataFrame and reset the index
        df_pivot = df_pivot.pivot_table(index='year_month',
                                        columns='SKU',
                                        values='StockValue',
                                        aggfunc='sum')
        df_pivot.index = pd.to_datetime(df_pivot.index)
        
        #Calculate yearly TSU mean and add deviation columns
        yearly_mean = df_pivot.loc[str(year)].mean()
        
        #Iterate over columns and add deviation columns
        deviation_columns = pd.DataFrame()
        for col in df_pivot.columns:
            product_name = col
            deviation = df_pivot[product_name] - yearly_mean[product_name]
            normalized_deviation = (df_pivot[product_name] - yearly_mean[product_name]) / (df_pivot[product_name].max() - df_pivot[product_name].min())
            deviation_columns[(f"{product_name}_Deviation")] = deviation
            deviation_columns[(f"{product_name}_NormalizedDeviation")] = normalized_deviation

        df_pivot = pd.concat([df_pivot, deviation_columns], axis=1)
        df_pivot = df_pivot.reindex(sorted(df_pivot.columns), axis=1)
        
        return df_pivot
    
#Create Tsu instances for each hospital 
lgh1_tsu = Tsu(hospitals_df,'LGH1')
lgh2_tsu = Tsu(hospitals_df,'LGH2')
lgh3_tsu = Tsu(hospitals_df,'LGH3')
msh1_tsu = Tsu(hospitals_df,'MSH1')
msh2_tsu = Tsu(hospitals_df,'MSH2')

#Call the month_sum_df method for each hospital
lgh1_month_tsu = lgh1_tsu.month_sum_df()
lgh2_month_tsu = lgh2_tsu.month_sum_df()
lgh3_month_tsu = lgh3_tsu.month_sum_df()
msh1_month_tsu = msh1_tsu.month_sum_df()
msh2_month_tsu = msh2_tsu.month_sum_df()

#Call the month_sum_by_medicine_df method for each hospital
lgh1_month_tsu_by_medicine_2020 = lgh1_tsu.month_sum_by_medicine_df(2020)
lgh1_month_tsu_by_medicine_2021 = lgh1_tsu.month_sum_by_medicine_df(2021)
lgh1_month_tsu_by_medicine_2022 = lgh1_tsu.month_sum_by_medicine_df(2022)
lgh1_month_tsu_by_medicine_2023 = lgh1_tsu.month_sum_by_medicine_df(2023)

lgh2_month_tsu_by_medicine_2020 = lgh2_tsu.month_sum_by_medicine_df(2020)
lgh2_month_tsu_by_medicine_2021 = lgh2_tsu.month_sum_by_medicine_df(2021)
lgh2_month_tsu_by_medicine_2022 = lgh2_tsu.month_sum_by_medicine_df(2022)
lgh2_month_tsu_by_medicine_2023 = lgh2_tsu.month_sum_by_medicine_df(2023)

lgh3_month_tsu_by_medicine_2020 = lgh3_tsu.month_sum_by_medicine_df(2020)
lgh3_month_tsu_by_medicine_2021 = lgh3_tsu.month_sum_by_medicine_df(2021)
lgh3_month_tsu_by_medicine_2022 = lgh3_tsu.month_sum_by_medicine_df(2022)
lgh3_month_tsu_by_medicine_2023 = lgh3_tsu.month_sum_by_medicine_df(2023)

msh1_month_tsu_by_medicine_2020 = msh1_tsu.month_sum_by_medicine_df(2020)
msh1_month_tsu_by_medicine_2021 = msh1_tsu.month_sum_by_medicine_df(2021)
msh1_month_tsu_by_medicine_2022 = msh1_tsu.month_sum_by_medicine_df(2022)
msh1_month_tsu_by_medicine_2023 = msh1_tsu.month_sum_by_medicine_df(2023)

msh2_month_tsu_by_medicine_2020 = msh2_tsu.month_sum_by_medicine_df(2020)
msh2_month_tsu_by_medicine_2021 = msh2_tsu.month_sum_by_medicine_df(2021)
msh2_month_tsu_by_medicine_2022 = msh2_tsu.month_sum_by_medicine_df(2022)
msh2_month_tsu_by_medicine_2023 = msh2_tsu.month_sum_by_medicine_df(2023)
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

### 1.6.3.1 Visualizing Total Stock usage (TSU) time series <br>

### 1.6.3.1.1 Total Stock usage (TSU) monthly averages by quarter in each hospital<br>
We used the monthly_avg_quarter_df method from he _TSU_ class to visualize the TSU variation among hospitals over time.<br>
##### Insights:<br>

* Historically, LGH2 has the highest TSU monthly average from 2020 to 2023.<br><br>
* MSH1 and MSH2 TSU monthly averages ranges from some thousands to a couple ten of thousands in contrast to the larger hospitals.<br><br>
* A decline in TSU is observed following the 2th quarter of 2021 in LGH1, LGH2 and LGH3.<br><br>
* LGH2 had the most drastic decrease in TSU monthly average from over $1,062,425 (2022_Q2) to aproximately $677,917 (2023_Q1), a decrease greater than 36% in one year or $384,508. This result is followed by a 29% decrease in LGH1 and a 24% in LGH3 in the same period.<br><br>
* The drastic decrease observed may be related to a severe cost reduction policy implemented.<br><br>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">index=['2020_Q1','2020_Q2','2020_Q3','2020_Q4','2021_Q1','2021_Q2','2021_Q3','2021_Q4','2022_Q1','2022_Q2','2022_Q3','2022_Q4','2023_Q1','2023_Q2']
       
tsu_average_by_quarter = pd.DataFrame(data={
                                            'Year_Quarter': index,
                                            'LGH1': lgh1_tsu.monthly_avg_quarter_df(),
                                            'LGH2': lgh2_tsu.monthly_avg_quarter_df(),
                                            'LGH3': lgh3_tsu.monthly_avg_quarter_df(),
                                            'MSH1': msh1_tsu.monthly_avg_quarter_df(),
                                            'MSH2': msh2_tsu.monthly_avg_quarter_df()
                                            }
                                    )


covid_dates = ['2020_Q1','2020_Q2','2020_Q3','2020_Q4','2021_Q1','2021_Q2','2021_Q3','2021_Q4','2022_Q1','2022_Q2','2022_Q3','2022_Q4','2023_Q1','2023_Q2']
covid_cases_quarter = [65691,99829,223370,236278,313483,379483,284718,205687,184953,98543,69854,58323,55968,50575]
covid_for_plotly = pd.DataFrame({"year_quarter":covid_dates, "Number of new COVID-19 cases":covid_cases_quarter})
tsu_average_by_quarter = pd.concat([tsu_average_by_quarter, covid_for_plotly], axis=1, join='outer')
tsu_average_by_quarter = tsu_average_by_quarter.drop(columns="year_quarter")
tsu_average_by_quarter
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html>

<br>
<caption><b>Table 5. Total Stock usage (TSU) monthly averages by quarter in each hospital.</b></caption>

|    | Year_Quarter |      LGH1     |     LGH2     |      LGH3     |     MSH1     |     MSH2    | Number of new COVID-19 cases |
|:--:|:------------:|:-------------:|:------------:|:-------------:|:------------:|:-----------:|:----------------------------:|
| 0  | 2020_Q1      | 584469.719803 | 1.005823e+06 | 394224.317504 | 15142.801151 | 1629.184566 | 65691                        |
| 1  | 2020_Q2      | 611123.858982 | 1.183376e+06 | 481970.147399 | 13452.095758 | 1835.331100 | 99829                        |
| 2  | 2020_Q3      | 762355.693219 | 1.063248e+06 | 445955.642822 | 17129.978427 | 1894.346501 | 223370                       |
| 3  | 2020_Q4      | 677922.616686 | 1.051400e+06 | 405286.835901 | 16262.291220 | 1570.892629 | 236278                       |
| 4  | 2021_Q1      | 729652.000549 | 9.353152e+05 | 484370.244446 | 16626.946719 | 1921.911455 | 313483                       |
| 5  | 2021_Q2      | 939892.998876 | 1.123392e+06 | 819098.354167 | 19352.070669 | 3065.312052 | 379483                       |
| 6  | 2021_Q3      | 595303.355057 | 9.987052e+05 | 481757.705896 | 17052.489648 | 2374.327521 | 284718                       |
| 7  | 2021_Q4      | 603629.149970 | 1.033993e+06 | 386744.003036 | 16410.879170 | 2208.455088 | 205687                       |
| 8  | 2022_Q1      | 515347.035820 | 9.303260e+05 | 458699.197765 | 14820.465187 | 2082.696870 | 184953                       |
| 9  | 2022_Q2      | 590182.515206 | 1.062425e+06 | 410737.299097 | 14014.073721 | 2623.604837 | 98543                        |
| 10 | 2022_Q3      | 489867.779233 | 1.020302e+06 | 358564.303953 | 13296.457535 | 2592.601316 | 69854                        |
| 11 | 2022_Q4      | 446807.078755 | 7.031597e+05 | 333782.060710 | 14453.159960 | 2836.337501 | 58323                        |
| 12 | 2023_Q1      | 416799.671392 | 6.779172e+05 | 311154.820465 | 14291.067702 | 2904.396312 | 55968                        |
| 13 | 2023_Q2      | 542799.468164 | 7.269198e+05 | 339136.741646 | 13754.758362 | 3864.039913 | 50575                        |

<br>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots

colors = ["#0173B2", "#DE8F05", "#029E73", "#D55E00", "#CC78BC"]

fig = px.line(
              tsu_average_by_quarter, x='Year_Quarter', y=['LGH1',
                                                           'LGH2',
                                                           'LGH3',
                                                           'MSH1',
                                                           'MSH2'],
              color_discrete_map={col: colors[idx] for idx, col in enumerate(tsu_average_by_quarter.columns[1:6])} 
            )
              
fig.add_trace(go.Scatter(
                         x=tsu_average_by_quarter['Year_Quarter'],
                         y=tsu_average_by_quarter['Number of new COVID-19 cases'],
                         mode='lines',
                         yaxis='y2',
                         name='Number of new COVID-19 cases',
                         line=dict(color='red', dash='dot')
                         )
            )

fig.update_layout(
    autosize=False, width=1200, height=800,
    title='Total Stock Usage (TSU) monthly average by quarter.',
    title_x=0.5,
    xaxis_title='Quarter',
    yaxis_title='TSU (million $)',
    yaxis2=dict(
        title='New Covid Cases (Thousands)',
        overlaying='y',
        side='right'
    ),
    xaxis=dict(showline=True, showgrid=False),
    yaxis=dict(showline=True, showgrid=False),
    paper_bgcolor='white',
    plot_bgcolor='lightgrey',
    font=dict(family='Open Sans', size=16, color='black'),
    legend=dict(font=dict(size=14), y=1.0, x=1.1),
    yaxis2_title_standoff=40
)
fig.update_yaxes(nticks=5, secondary_y=True)
fig.show()
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

{% include figure.html path="/assets/img/figure2_tsu_quarter.png" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 2. Total Stock Usage (TSU) monthly average by quarter.</div>

<br>

### 1.6.3.1.2 Total Stock usage (TSU) by month in each hospital

#### Insights:<br>

* In the time period depicted, the TSU line plots show a increase from 2020 to 2021 and a deacrease in 2022 and 2023;
* The prominent increase in TSU in the first 2 quarter of 2021 coincides with the peak in the number of cases of infections with the Sars-Cov2 virus (COVID19) and hospitalizations, except for LGH2.

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(18,8))
sns.set_style("whitegrid", {'grid.linestyle': ':'})
fig.subplots_adjust(left=0.15, top=0.95)    

def tsu_line_plotter(df,ax):
    sns.set_style("whitegrid", {'grid.linestyle': ':'})
    palette = sns.color_palette(["#0173B2", "#DE8F05", "#029E73", "#D55E00"], as_cmap=True)
    plot = sns.lineplot(data=df,x='Month',y=df['TSU']/1000, hue='Year', ax=ax, palette=palette)
    plt.tight_layout(pad=5)
    sns.move_legend(ax,loc='upper right', title=None, frameon=False,fontsize=8)
    ax.set_yticks(ax.get_yticks())
    ax.set_xlabel('Month')
    ax.set_ylabel('TSU (K$)')
    ax.set_title(df['SenderLocationID'][0])
    ax.set_xticks(ax.get_xticks())
    plot.set(xlim=(0,12))
    sns.set(style="ticks")

tsu_line_plotter(lgh1_month_tsu,axes[0,0])
tsu_line_plotter(lgh2_month_tsu,axes[0,1])
tsu_line_plotter(lgh3_month_tsu,axes[0,2])
tsu_line_plotter(msh1_month_tsu,axes[1,0])
tsu_line_plotter(msh2_month_tsu,axes[1,1])

axes[1,2].set_axis_off()
plt.legend(loc='upper right', title='Year')
plt.grid()
sns.set_style("whitegrid", {'grid.linestyle': ':'})
fig.suptitle('TSU by month over the years across hospitals.')
plt.show()
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

{% include figure.html path="/assets/img/figure3_tsu_years.png" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 3. Total Stock Usage (TSU) by month over the years across hospitals.</div>
<br>

### 1.6.3.2 Total Stock usage (TSU) across hospital departments (TOP 10)

We identified the top 10 hospital departments with the highest TSU in the first quarter of 2023.

#### Insights:<br><br>

* The emergency departments of the larger hospitals are the top stock consumers. At least half of the pharmacy stock was used in the emergency departments in the first quarter of 2023.<br><br>
* LGH1 has a very busy Gynecology and Obstetrics department. In LGH2 the Nephrology dept. and LGH3 stands out for its ICU.<br><br>
* MSH1 and MSH2 are much smaller hospitals specialized in psychiatry and cancer patients palliative care, respectively.<br><br>
* Their stock usage reflects the specialization.<br><br>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">#Create bar plots for the pharmacy stock usage across hospitals departments - tops 10 departments
fig, axes = plt.subplots(2, 3, figsize=(20,10))
sns.set(style="darkgrid")

lgh1_bar_plot = sns.barplot(data=lgh1_tsu.quarter_sum_by_dept_df(2023,1).nlargest(10, 'StockValue'),
                            x='StockValue',
                            y='ReceiverName',
                            palette="colorblind",
                            ax=axes[0,0])

lgh1xlabels = ['{:,.0f}'.format(x) + 'K' for x in lgh1_bar_plot.get_xticks()/1000]

lgh2_bar_plot = sns.barplot(data=lgh2_tsu.quarter_sum_by_dept_df(2023,1).nlargest(10, 'StockValue'),
                            x='StockValue',
                            y='ReceiverName',
                            palette="colorblind",
                            ax=axes[0,1])

lgh2xlabels = ['{:,.0f}'.format(x) + 'K' for x in lgh2_bar_plot.get_xticks()/1000]

lgh3_bar_plot = sns.barplot(data=lgh3_tsu.quarter_sum_by_dept_df(2023,1).nlargest(10, 'StockValue'),
                            x='StockValue',
                            y='ReceiverName',
                            palette="colorblind",
                            ax=axes[0,2])

lgh3xlabels = ['{:,.0f}'.format(x) + 'K' for x in lgh3_bar_plot.get_xticks()/1000]

msh1_bar_plot = sns.barplot(data=msh1_tsu.quarter_sum_by_dept_df(2023,1).nlargest(10, 'StockValue'),
                            x='StockValue',
                            y='ReceiverName',
                            ax=axes[1,0])

msh1xlabels = ['{:,.0f}'.format(x) + 'K' for x in msh1_bar_plot.get_xticks()/1000]

msh2_bar_plot = sns.barplot(data=msh2_tsu.quarter_sum_by_dept_df(2023,1).nlargest(10, 'StockValue'),
                            x='StockValue',
                            y='ReceiverName',
                            ax=axes[1,1])

msh2xlabels = ['{:,.0f}'.format(x) + 'K' for x in msh2_bar_plot.get_xticks()/1000]

#Subtitles and axis labels
axes[0,0].set_title('LGH1')
axes[0,0].set_xlabel('Stock usage ($)')
axes[0,0].set_ylabel('Department')
axes[0,0].set_xticks(axes[0,0].get_xticks().tolist())
axes[0,0].set_xticklabels(labels=lgh1xlabels, rotation=0)
axes[0,1].set_title('LGH2')
axes[0,1].set_xlabel('Stock usage ($)')
axes[0,1].set_xticks(axes[0,1].get_xticks().tolist())
axes[0,1].set_xticklabels(labels=lgh2xlabels, rotation=0)
axes[0,1].set_ylabel(None)
axes[0,2].set_title('LGH3')
axes[0,2].set_xlabel('Stock usage ($)')
axes[0,2].set_xticks(axes[0,2].get_xticks().tolist())
axes[0,2].set_xticklabels(labels=lgh3xlabels, rotation=0)
axes[0,2].set_ylabel(None)
axes[1,0].set_title('MSH1')
axes[1,0].set_xlabel('Stock usage ($)')
axes[1,0].set_xticks(axes[1,0].get_xticks().tolist())
axes[1,0].set_xticklabels(labels=msh1xlabels, rotation=0)
axes[1,0].set_ylabel('Department')
axes[1,1].set_title('MSH2')
axes[1,1].set_xlabel('Stock usage ($)')
axes[1,1].set_xticks(axes[1,1].get_xticks().tolist())
axes[1,1].set_xticklabels(labels=msh2xlabels, rotation=0)
axes[1,1].set_ylabel(None)
axes[1,2].set_axis_off()

fig.tight_layout()
fig.suptitle('Top 10 departments - 2023-Q1 stock usage', fontsize=16)
plt.subplots_adjust(top=0.90)
plt.show()
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

{% include figure.html path="/assets/img/figure4_tsu_top_dept.png" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 4. Total Stock Usage (TSU) across hospital departments (2023-Q1).</div>
<br>


### 1.6.3.3 Deviation from the mean TSU
In order to analyse the behaviour of Total Stock Usage (TSU) along the year, we defined a function to visualize the deviation from the mean values for a given year. We had previously created a column named 'Normalized (mean) deviation from the mean'.<br>

In the resulting multiplot, a red dashed line represents the mean yealy TSU value for each hospital.In each plot the blue line represents the deviations from the mean TSU value, after the normalization process.<br><br>

#### Insights:<br><br>

* There is not a clear picture of seasonality at the aggregate level.<br><br>
* It is well known that the Sars-CoV (COVID-19) pandemic resulted in an increase in the numbers os hospitalization as well as prices of medications and other healt-related products.<br><br>
* In contrast, some healthcare services and elective surgeries procedures where almost haulted during the pandemic.<br><br>
* Further analysis by medicine should allow the identification of groups of seasonal products and their impact in the TSU.<br><br>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b><b>Click to expand/collapse code</b></b></summary>
    <pre class="line-numbers"><code class="language-python">fig, axes = plt.subplots(nrows=4, ncols=5, figsize=(30,20))

lgh1_2020,lgh1_2021,lgh1_2022,lgh1_2023 = axes[0,0],axes[1,0],axes[2,0],axes[3,0]
lgh2_2020,lgh2_2021,lgh2_2022,lgh2_2023 = axes[0,1],axes[1,1],axes[2,1],axes[3,1]
lgh3_2020,lgh3_2021,lgh3_2022,lgh3_2023 = axes[0,2],axes[1,2],axes[2,2],axes[3,2]
msh1_2020,msh1_2021,msh1_2022,msh1_2023 = axes[0,3],axes[1,3],axes[2,3],axes[3,3]
msh2_2020,msh2_2021,msh2_2022,msh2_2023 = axes[0,4],axes[1,4],axes[2,4],axes[3,4]

def tsu_line_plotter_deviation_from_mean(df,ax,year):
    # Plot a red dotted line indicating the mean
    plt.axhline(y=0, color='r', linestyle='dotted', label='Mean', linewidth=2)
    sns.lineplot(data=df.loc[df['Year'] == year],x='Month',y=df['Normalized (mean) deviation from the mean'], ax=ax,color="b")
    ax1 = ax.twinx()
    #sns.lineplot(data=df,x='Month',y=df['Yearly TSU average']/1000,ax=ax1,color="r")
    #ax.set_xticks(ax.get_xticks())
    ax.set_yticks(ax.get_yticks())
    ax.set_xlabel('Month')
    ax.set_xticklabels(labels=df['Month'])
    ax.set_ylabel('Deviation (mean normalized)',color="b")
    ax1.set_ylabel('TSU average',color="r")
    #ax.set_xticks(range(len(df['Month'])))
    #ax1.set_yticks(ax1.get_yticks())
    sns.set_style("whitegrid", {'grid.linestyle': ':'})
    ax.set_ylim(-0.7,0.7)
    ax1.set_ylim(-0.7,0.7)
    #ax.set_ylim(min(df['Normalized (mean) deviation from the mean'].loc[df['Year'] == year]), max(df['Normalized (mean) deviation from the mean'].loc[df['Year'] == year]))
    #ax1.set_ylim(min(df['Normalized (mean) deviation from the mean'].loc[df['Year'] == year]), max(df['Normalized (mean) deviation from the mean'].loc[df['Year'] == year]))
    
tsu_line_plotter_deviation_from_mean(lgh1_month_tsu, lgh1_2020, 2020)
tsu_line_plotter_deviation_from_mean(lgh1_month_tsu, lgh1_2021, 2021)
tsu_line_plotter_deviation_from_mean(lgh1_month_tsu, lgh1_2022, 2022)
tsu_line_plotter_deviation_from_mean(lgh1_month_tsu, lgh1_2023, 2023)
tsu_line_plotter_deviation_from_mean(lgh2_month_tsu, lgh2_2020, 2020)
tsu_line_plotter_deviation_from_mean(lgh2_month_tsu, lgh2_2021, 2021)
tsu_line_plotter_deviation_from_mean(lgh2_month_tsu, lgh2_2022, 2022)
tsu_line_plotter_deviation_from_mean(lgh2_month_tsu, lgh2_2023, 2023)
tsu_line_plotter_deviation_from_mean(lgh3_month_tsu, lgh3_2020, 2020)
tsu_line_plotter_deviation_from_mean(lgh3_month_tsu, lgh3_2021, 2021)
tsu_line_plotter_deviation_from_mean(lgh3_month_tsu, lgh3_2022, 2022)
tsu_line_plotter_deviation_from_mean(lgh3_month_tsu, lgh3_2023, 2023)
tsu_line_plotter_deviation_from_mean(msh1_month_tsu, msh1_2020, 2020)
tsu_line_plotter_deviation_from_mean(msh1_month_tsu, msh1_2021, 2021)
tsu_line_plotter_deviation_from_mean(msh1_month_tsu, msh1_2022, 2022)
tsu_line_plotter_deviation_from_mean(msh1_month_tsu, msh1_2023, 2023)
tsu_line_plotter_deviation_from_mean(msh2_month_tsu, msh2_2020, 2020)
tsu_line_plotter_deviation_from_mean(msh2_month_tsu, msh2_2021, 2021)
tsu_line_plotter_deviation_from_mean(msh2_month_tsu, msh2_2021, 2021)
tsu_line_plotter_deviation_from_mean(msh2_month_tsu, msh2_2021, 2021)
tsu_line_plotter_deviation_from_mean(msh2_month_tsu, msh2_2022, 2022)
tsu_line_plotter_deviation_from_mean(msh2_month_tsu, msh2_2023, 2023)

cols = ['LGH1','LGH2','LGH3','MSH1','MSH2']
rows = [2020, 2021, 2022, 2023]

column_fontsize = 16
row_fontsize = 16

pad = 10 # in points

for ax, col in zip(axes[0], cols):
    ax.annotate(col, xy=(0.5, 1), xytext=(0, pad),
                xycoords='axes fraction', textcoords='offset points',
                size=column_fontsize, ha='center', va='baseline')
    
for ax, row in zip(axes[:,0], rows):
    ax.annotate(row, xy=(0, 0.5), xytext=(-ax.yaxis.labelpad - pad, 0),
                xycoords=ax.yaxis.label, textcoords='offset points',
                size=row_fontsize, ha='right', va='center')
    
fig.subplots_adjust(left=0.15, top=0.80)    
fig.tight_layout(pad=7,w_pad=3)
fig.suptitle('Mean Normalized Deviation from the yearly TSU average', fontsize=24)
plt.show()
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>

{% include figure.html path="/assets/img/figure5_dev_from_mean.png" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 5. Mean Normalized Deviation from the yearly Total Stock Usage (TSU) average.</div>

## 2. Data load into a PostGreSQL database
The processed data were exported to a csv file and then inserted into a table in an existing PostGreSQL database.<br><br>

### 2.1 PostGreSQL table creation.

SUBSTITUIR FIGURA STOCK VALUE TEM QUE SER EM DECIMAL OU NUMERIC. DOUBLE NÃO!
<!-- <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>
<body>
<details>
    <summary><b>Click to expand/collapse code</b></summary>
    <pre class="line-numbers"><code class="language-sql">CREATE TABLE IF NOT EXISTS public.hospitals_fact
(
	"SenderLocationID" character varying(30) COLLATE pg_catalog."default" NOT NULL,
	"OrderID" character varying(30) COLLATE pg_catalog."default" NOT NULL,
	"Date" date,
	"ReceiverID" character varying(30) COLLATE pg_catalog."default" NOT NULL,
	"ReceiverName" character varying(100) COLLATE pg_catalog."default" NOT NULL,
	"InOut" "char",
	"MovementType" character varying(20) COLLATE pg_catalog."default" NOT NULL,
	"SKU" character varying(12) COLLATE pg_catalog."default" NOT NULL,
	"Product" character varying(100) COLLATE pg_catalog."default" NOT NULL,
	"ClassID" character varying(12) COLLATE pg_catalog."default" NOT NULL,
	"ClassName" character varying(200) COLLATE pg_catalog."default" NOT NULL,
	"MeasurementUnit" character varying(5) COLLATE pg_catalog."default" NOT NULL,
	"StandartPrice" double precision,
	"Quantity" double precision NOT NULL,
	"RemainingStock" double precision NOT NULL,
	"StockValue" double precision NOT NULL,
	CONSTRAINT hospitals_fact_pkey PRIMARY KEY ("SenderLocationID", "OrderID", "SKU", "Quantity")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hospitals_fact
	OWNER to postgres;
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>-->

{% include figure.html path="/assets/img/figure6_postgre_table_creation.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 6. Table creation in a PostGreSQL database.</div>
<br>



### 2.2 Processed data load into table.

{% include figure.html path="/assets/img/figure7_postgre_csv_load.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 7. Data load into the PostGreSQL.</div>

### 2.3 Test query after index creation.

{% include figure.html path="/assets/img/figure8_postgre_test_query.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 8. Test query.</div>
<br>


## 3. Visualizations, metrics and reports in PowerBI
In Power BI, SQL queries were designed to retrieve information from the database in order to construct reports with relevant metrics for managerial purposes.<br><br>

We created 4 Report pages:
* **Report 1 - Pharmacy Stock Availability, Coverage and Usage.**<br><br>
The client was particularly interest in the stock availavility and coverage across hospitals, the inventory turnover ratio, the total stock value each hospital holds at any moment.<br>
There was also interest in analysing the stock usage by quarter and the deviation from a goal determined by the board of directors.<br><br>
* **Report 2 - ABC Analysis.**<br><br>
There was also interest in analysing the stock usage by quarter and the deviation from a goal determined by the board of directors.<br><br>
* **Report 3 - Stock Usage by Hospital by week of the year/quarter.**<br><br>
Managers also needed to follow the distribution of inventory categories, using ABC analysis, and to monitor the total stock usage by hospital department along with the most expensive products.<br><br>
* **Report 4 - Stock Usage by Hospital Department.**<br><br>
In order to prevent performance and other issues, is it is preferable to perform calculations as upstream as possible. However, we used a mix of queries in PowerQuery and metrics/calculated columns using DAX to further demonstrate our ability to use these alternatives.<br><br>

{% include figure.html path="/assets/img/figure9_prostgres_query_ example.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 9. Example of a PostGreSQL query used to populate tables in Power Bi.</div>
<br>

##### PowerBI Report 1 - Pharmacy Stock Availability, Coverage and Usage.

{% include figure.html path="/assets/img/figure10_powerbi_page1_availability_and_coverage.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 10. PowerBI report 1</div>
<br>

##### PowerBI Report 2 - ABC Analysis.

{% include figure.html path="/assets/img/figure11_powerbi_page2_abc_analysis.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
<div class="caption">Figure 11. PowerBI report 2</div>
<br>

##### PowerBI Report 3 - Stock Usage by Hospital by week of the year/quarter.

{% include figure.html path="/assets/img/figure12_powerbi_page3_stock_usage_by_hospital_by_week.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
<div class="caption">Figure 12. PowerBI report 3</div>
<br>

##### PowerBI Report 4 - Stock Usage by Hospital Department.

{% include figure.html path="/assets/img/figure13_powerbi_page4_stock_usage_by_hospital.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
<div class="caption">Figure 13. PowerBI report 4</div>
<br><br>
<br>


## Conclusion

In this first part of the YellowLynx MedCorp Case Study, it was possible to accomplish the goals of the proposed case study:

1. To demonstrate end-to-end capability in understanding business problems and proposing solutions, always using an analytical mindset and attention to detail.<br>

2. To demonstrate proficiency in relational databases, SQL language and Python for data cleaning/preparation, analysis, and insights.<br>

3. To demonstrate the ability to integrate and summarize the acquired knowledge in reports, executive summaries, and dashboards that provide relevant information related to inventory management and financial expenditures information to the executive team in a timely and reliable manner.<br><br>

In the second part, we will evaluate medicine usage prediction in the hospital context using and  designing forecast models to achieve this goal.

<hr>