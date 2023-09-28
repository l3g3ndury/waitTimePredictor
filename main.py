import numpy as np
import pandas as pd
import sklearn.model_selection
import sklearn.linear_model
import sklearn.metrics as metrics
import matplotlib.pyplot as plt

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

# ==============================================================================
# Narrowing the data up for sample testing, as opposed to all data testing
# ==============================================================================

summerData = metaAvatarNew[(metaAvatarNew.MONTHOFYEAR == 5)|(metaAvatarNew.MONTHOFYEAR == 6)|(metaAvatarNew.MONTHOFYEAR == 7)|(metaAvatarNew.MONTHOFYEAR == 8)]

summerData2021 = summerData[summerData.YEAR == 2021]

actualTime = summerData2021.iloc[:,0:2]
actualTime.index = range(102)
summerData2021Dates = summerData2021.iloc[:,0:1]

# ==============================================================================
# Prediction Model Via Simple Linear Regresssion
# ==============================================================================

predictSummer2021 = summerData2021[featureList]

linear = sklearn.linear_model.LinearRegression()
model = linear.fit(xTrain, yTrain)
# yLinearPrediction = linear.predict(xTest)
yLinearPrediction = linear.predict(predictSummer2021)

# print('Mean Absolute Error:', metrics.mean_absolute_error(yTest, yLinearPrediction))
# print('Mean Squared Error:', metrics.mean_squared_error(yTest, yLinearPrediction))
# print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(yTest, yLinearPrediction)))
#
# # Caculating Error
# error = round(metrics.mean_absolute_error(yTest, yLinearPrediction), 2)
# meanAPE = 100 * (error / yTest)
# accuracy = (100 - np.mean(meanAPE)).round(2,)
#
# print('Accuracy:', round(accuracy, 2), '%')

yLinearPrediction = pd.DataFrame(yLinearPrediction)
yComparison = pd.concat([actualTime, yLinearPrediction], axis=1)
yComparison = yComparison.rename({"date": "Date", "SPOSTMIN": "actualTime", 0: "predictedTime"}, axis=1)
yComparison.predictedTime = np.exp(yComparison.predictedTime)
print(yComparison)

plt.plot(yComparison.Date, yComparison.predictedTime, "b-", label="Predicted")
plt.plot(yComparison.Date, yComparison.actualTime, "ro", label="Actual", markersize=3)

plt.xticks(rotation=60)
plt.legend()

plt.xlabel("Date")
plt.ylabel("Average Wait Time")
plt.title("Actual and Predicted Wait Times")

plt.show()