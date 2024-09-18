import datetime

# List of topics
topics = [
    "Introduction",
    "Compute Resources",
    "Unix",
    "Docker",
    "git basics & github basics",
    "How to Think about Programming & More R",
    "Tidyverse for Tidying & GGPlot",
    "Make and Makefiles",
    "git concepts and practices",
    "Markdown, RMarkdown, Notebooks, L",
    "Project Organization",
    "Dimensionality Reduction",
    "Clustering",
    "Classification",
    "Model Validation and Selection",
    "Shiny",
    "Introduction to Scientific Python",
    "SQL (and pandas, dplyr)",
    "Pandas & SQL",
    "SKLearn Introduction",
    "Training Neural Networks",
    "Bokeh",
    "Browser Based Visualization w/ d3",
    "Data Science Ethics",
    "Web Scraping",
    "Class Presentations I",
    "Class Presentations II"
]

# List of holidays and special events with emojis
holidays = {
    datetime.date(2024, 9, 2): "Labor Day 🌟",
    datetime.date(2024, 10, 11): "University Day 🎓",
    datetime.date(2024, 9, 3): "Well-being Day 🧘",
    datetime.date(2024, 9, 23): "Well-being Day 🧘",
    datetime.date(2024, 10, 17): "Fall Break 🍁",
    datetime.date(2024, 10, 18): "Fall Break 🍁",
    datetime.date(2024, 11, 27): "Thanksgiving Recess 🦃",
    datetime.date(2024, 11, 28): "Thanksgiving Recess 🦃",
    datetime.date(2024, 11, 29): "Thanksgiving Recess 🦃",
    datetime.date(2024, 12, 4): "Classes End 📚",
    datetime.date(2024, 12, 5): "Reading Day 📖",
    datetime.date(2024, 12, 11): "Reading Day 📖",
    datetime.date(2024, 12, 6): "Exam Day 📝",
    datetime.date(2024, 12, 7): "Exam Day 📝",
    datetime.date(2024, 12, 9): "Exam Day 📝",
    datetime.date(2024, 12, 10): "Exam Day 📝",
    datetime.date(2024, 12, 12): "Exam Day 📝",
    datetime.date(2024, 12, 13): "Exam Day 📝",
    datetime.date(2024, 12, 15): "Fall Commencement 🎓"
}

# Starting date
start_date = datetime.date(2024, 8, 19)

# Dictionary to hold the schedule
schedule = {}

# Iterate over the topics and assign them to Mondays and Wednesdays
topic_index = 0
current_date = start_date
while topic_index < len(topics):
    if current_date.weekday() in [0, 2]:  # 0 is Monday, 2 is Wednesday
        if current_date in holidays:
            schedule[current_date] = holidays[current_date]
        else:
            schedule[current_date] = topics[topic_index]
            topic_index += 1
    current_date += datetime.timedelta(days=1)

# Print the schedule
for date, topic in schedule.items():
    weekday = date.strftime('%A')
    if date in holidays:
        print(f"{date.strftime('%Y-%m-%d')} ({weekday}): {topic}")
    else:
        print(f"{date.strftime('%Y-%m-%d')} ({weekday}): {topic} (3:30 PM - 4:50 PM)")
