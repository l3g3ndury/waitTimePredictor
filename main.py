import pandas as pd

meta = pd.read_csv("datasets/metadata.csv")
avatar = pd.read_csv("datasets/flight_of_passage.csv")

print(meta)
print(avatar)

avatar = avatar[avatar.SPOSTMIN > 0]

metaAvatar = pd.merge(avatar, meta, left_on="date", right_on="DATE")
metaAvatar = metaAvatar.drop("DATE", axis=1)

print(metaAvatar)
