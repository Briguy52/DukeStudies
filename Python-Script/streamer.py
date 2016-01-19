import json
import requests

subjects_output = [] # Array for output json

streamer_url = "https://streamer.oit.duke.edu/curriculum/courses/subject/"
streamer_url_suffix = "?access_token=6448bb1e9d6f2380428de491aaa83cf0"

with open("subjects.json") as json_file:
  json_data = json.load(json_file)
  values = json_data["values"]

  for value in values:
    print("Code: " + value["code"])
    print("Description: " + value["desc"])

    r = requests.get(streamer_url + value["code"] + streamer_url_suffix)
    r_json = r.json()
    course_count = r_json["ssr_get_courses_resp"]["course_search_result"]["ssr_crs_srch_count"]
    if r_json["ssr_get_courses_resp"]["course_search_result"]["subjects"]["subject"]["course_summaries"]:
      courses = r_json["ssr_get_courses_resp"]["course_search_result"]["subjects"]["subject"]["course_summaries"]["course_summary"]
      # Force object into list, because Streamer API JSON is not structured correctly - may result in single course
      # ...NOT an array of one course
      if not isinstance(courses, list):
        courses = [courses]
    
    courses_output = []
    for course in courses:
      courses_output.append({
        "course_number": course["catalog_nbr"].strip(),
        "course_title": course["course_title_long"],
        "crse_id": course["crse_id"],
        })

    subjects_output.append({
      "code": value["code"],
      "desc": value["desc"],
      "courses": courses_output
      })

with open("courses.json", "w") as outfile:
  json.dump(subjects_output, outfile)
