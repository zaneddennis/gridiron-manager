import pandas as pd


# last names
# TODO: exclude Name=""
df = pd.read_csv("Names_2010Census.csv").iloc[:-1]  # exclude "All Other Names"
df = df[["name", "prop100k"]]
df.columns = ["Name", "Per100k"]
df.Name = df.Name.str.capitalize()
df.to_csv("last_names.csv", index=False)

# first names
dfs = []
for year in range(1960, 2023+1):
    x = pd.read_csv(f"yob{year}.txt", header=None)
    x.columns = ["Name", "Sex", "Count"]
    x["Year"] = year

    x = x.loc[x.Sex == "M"]

    dfs.append(x)

df = pd.concat(dfs)
total = df["Count"].sum()
df["Per100k"] = 100000 * df["Count"] / total

df[["Name", "Year", "Per100k"]].to_csv("first_names.csv", index=False)