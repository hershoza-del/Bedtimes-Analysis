import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv("/Users/hershoza/Downloads/bedtime_screentime_sleep_debt.csv")

#where my graphs will be saved within my folder
output_dir = os.path.join(os.path.expanduser("~"), "bedtime charts")
os.makedirs(output_dir, exist_ok=True)

def save_path(filename):
    return os.path.join(output_dir, filename)

print(f"Charts will be saved to: {output_dir}")

#brief analysis of dataset before altering it
print(df.shape)
print(df.info())
print(df.describe())

print(df.isnull().sum())
print(df.duplicated().sum())

summary = df.groupby("occupation_type")["bedtime_phone_minutes"].mean()
print(summary)

#altering the dataset
df = df.drop(columns=["gender", "deep_sleep_pct", "rem_sleep_pct", 
                      "screen_brightness_pct", "blue_light_filter_active",
                      "sleep_debt_category"])

df["occupation_type"] = df["occupation_type"].replace(
    {
        "Healthcare / Shift Worker": "Shift",
        "Remote Tech": "Remote",
        "Freelance / Creative": "Freelance",
        "Corporate 9-to-5": "Corporate"
    }
)

df["primary_bedtime_app"] = df["primary_bedtime_app"].replace(
    {
        "Instagram / Reddit": "Instagram/Reddit",
        "TikTok / Reels": "TikTok/Reels",
        "News / Reading": "News/Reading",
        "Streaming (Netflix/Hulu)": "Streaming",
        "Messaging / Chat": "Messaging"
    }
)

#boxplot, barchart, and scatterplot charts
fig, ax = plt.subplots(figsize=(8, 5))
df.boxplot(column="total_sleep_hours", by="occupation_type", ax=ax, grid=False,
           patch_artist=True,
           boxprops=dict(facecolor="orange", edgecolor="black"),
           color=dict(whiskers="black", caps="black", medians="black"))
ax.set_title("Sleep Duration Across Occupation Groups")
fig.suptitle("")           
ax.set_xlabel("Occupation Type")
ax.set_ylabel("Total Sleep Hours")
fig.tight_layout()
fig.savefig(save_path("boxplot.png"), dpi=150)
plt.close(fig)

bands = ["0 mg", "1–50 mg", "51–100 mg", "101–250 mg"]
df["caffeine_band"] = pd.cut(df["caffeine_post_5pm_mg"], bins=[-1, 0, 50, 100, 250], labels=bands)

stats = df.groupby("caffeine_band", observed=True)["sleep_latency_min"].agg(["mean", "count"]).reindex(bands)
latency = stats["mean"]

fig, ax = plt.subplots(figsize=(8, 5))
latency.plot(kind='bar', stacked=True, ax=ax, color="black", edgecolor="black")
for i, (mean, n) in enumerate(zip(stats["mean"], stats["count"])):
    ax.text(i, mean + 0.5, f"{mean:.1f} min\n(n = {n:,})", ha="center", va="bottom")
ax.set_ylim(0, latency.max() * 1.2)
ax.set_title("Average Time to Fall Asleep by Evening Caffeine Intake")
ax.set_xlabel("Caffeine After 5 PM")
ax.set_ylabel("Mean Time to Fall Asleep (minutes)")
ax.legend(["Mean time to fall asleep"], loc="upper left")
plt.xticks(rotation=20, ha="right")
fig.tight_layout()
fig.savefig(save_path("barchart.png"), dpi=150)
plt.close(fig)

jitter = np.random.uniform(-0.2, 0.2, size=len(df))
fig, ax = plt.subplots(figsize=(8, 5))
ax.scatter(df["bedtime_phone_minutes"] + jitter, df["sleep_latency_min"], alpha=0.1, s=10, color="blue") 
ax.set_title("Bedtime Phone Use and Time to Fall Asleep")
ax.set_xlabel("Bedtime Phone Minutes")
ax.set_ylabel("Sleep Latency Minutes")
fig.tight_layout()
fig.savefig(save_path("scatterplot.png"), dpi=150)
plt.close(fig)

#export alterations to excel
df.to_excel("/Users/hershoza/Downloads/Bedtime.xlsx", index=False)






