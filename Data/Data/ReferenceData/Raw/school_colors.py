import pandas as pd


def unpack_line(line, verbose=False):
    k, v = line.split("]={")
    k = "".join([c for c in k if c.isalnum() or c == " "])
    if verbose:
        print(k)

    v = v.split(",")[:3]
    if verbose:
        print("\t", v)
    v = [color.replace(" ", "").strip("{}\"") for color in v if "name" not in color]
    v = ["#" + color for color in v if len(color) == 6]
    if verbose:
        print("\t", v)

    return [k, *v]

with open("school_colors_wikipedia.txt") as f:
    x = []

    i = 0
    for line in f:
        line = line.replace("] = {", "]={")
        if "]={" in line:
            result = unpack_line(line, i == 588 or i == 6 or i == 0)
            x.append(result)
        i += 1

    df = pd.DataFrame(x, columns=["School", "Color1", "Color2", "Color3"])
    df = df.astype(str)
    print(df)
    df.to_csv("school_colors_extracted.csv", index=False, sep="\t")
