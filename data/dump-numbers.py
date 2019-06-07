"""
Usage::

    django-admin shell <dump-numbers.py

"""
import csv
import sys

from django.utils.timezone import localtime

from khetha import models

task = models.Task.objects.get(slug="contact-details")

writer = csv.writer(sys.stdout, dialect="unix")
writer.writerow(
    ["user_key", "timestamp", *[question.text for question in task.questions()]]
)

submission: models.TaskSubmission
for submission in task.tasksubmission_set.order_by("created_at"):
    answers = [
        answer.value for answer in submission.answer_set.order_by("question__order")
    ]
    if all(answers):
        writer.writerow(
            [submission.user_key, localtime(submission.created_at), *answers]
        )
