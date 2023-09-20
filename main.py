import pandas as pd

meta = pd.read_csv("datasets/metadata.csv")
avatar = pd.read_csv("datasets/flight_of_passage.csv")

print(meta)
print(avatar)

avatar = avatar[avatar.SPOSTMIN > 0]

metaAvatar = pd.merge(avatar, meta, left_on="date", right_on="DATE")
metaAvatar = metaAvatar.drop("DATE", axis=1)
metaAvatar["date"] = pd.to_datetime(metaAvatar["date"])
metaAvatar = metaAvatar.fillna(0)

print(metaAvatar)

averageByDate = metaAvatar.groupby("date")["SPOSTMIN"].mean()
averageByDate = averageByDate.reset_index()
averageByDate = pd.DataFrame(averageByDate, columns=["date","SPOSTMIN"])

print (averageByDate)

meta["DATE"] = pd.to_datetime(meta["DATE"])

metaAvatarNew = pd.merge(averageByDate, meta, left_on="date", right_on="DATE")
metaAvatarNew = metaAvatarNew.drop("DATE", axis=1)
metaAvatarNew = metaAvatarNew.fillna(0)

print(metaAvatarNew)
