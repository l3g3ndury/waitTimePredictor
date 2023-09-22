import numpy as np
import pandas as pd
import sklearn.model_selection

meta = pd.read_csv("datasets/metadata.csv")
avatar = pd.read_csv("datasets/flight_of_passage.csv")

avatar = avatar[avatar.SPOSTMIN > 0]

metaAvatar = pd.merge(avatar, meta, left_on="date", right_on="DATE")
metaAvatar = metaAvatar.drop("DATE", axis=1)
metaAvatar["date"] = pd.to_datetime(metaAvatar["date"])
metaAvatar = metaAvatar.fillna(0)
metaAvatar.head()

averageByDate = metaAvatar.groupby("date")["SPOSTMIN"].mean()
averageByDate = averageByDate.reset_index()
averageByDate = pd.DataFrame(averageByDate, columns=["date", "SPOSTMIN"])

meta["DATE"] = pd.to_datetime(meta["DATE"])

metaAvatarNew = pd.merge(averageByDate, meta, left_on="date", right_on="DATE").drop("DATE", axis=1)
metaAvatarNew = metaAvatarNew.fillna(0)
metaAvatarNew.head()

print(metaAvatarNew)

# As the rule for featureList gets smaller, the more features are found. Ideally, we want the right amount of features.
rule = 0.20
metaAvatarNew_corr = metaAvatarNew.corr(numeric_only=True)["SPOSTMIN"][:-2]
featureList = metaAvatarNew_corr[abs(metaAvatarNew_corr) > rule].sort_values(ascending=False)

print("{} strongly correlated values found with SPOSTMIN:\n{}".format(len(featureList), featureList))

# Modified the feature list to remove SPOSTMIN, now that we have it.
featureList = featureList.to_frame()
featureList = featureList.reset_index()
featureList = featureList.iloc[:, 0]
featureList = featureList.to_list()
featureList.remove("SPOSTMIN")

x = metaAvatarNew[featureList]
y = metaAvatarNew["SPOSTMIN"]

# Setting up model based on data manipulation above.
xTrain, xTest, yTrain, yTest = sklearn.model_selection.train_test_split(x, y, test_size=0.25)

yTrain = np.log(yTrain)
yTest = np.log(yTest)

print('Number of observations:', x.shape[0])
print('Number of predictors:', x.shape[1])