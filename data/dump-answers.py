"""
Usage::

    django-admin shell <dump-answers.py

"""
import csv
import sys

from django.utils.timezone import localtime

from khetha import models


answers = (
    models.Answer.objects.order_by("created_at")
    .exclude(value="")
    .prefetch_related("question", "tasksubmission", "tasksubmission__task")
)

writer = csv.writer(sys.stdout, dialect="unix")
writer.writerow(
    [
        "user_key",
        "submission id",
        "submission complete",
        "timestamp",
        "task slug",
        "question id",
        "question text",
        "answer",
    ]
)

for answer in answers:
    submission: models.TaskSubmission = answer.tasksubmission
    writer.writerow(
        [
            submission.user_key,
            submission.id,
            submission.is_completed(),
            localtime(answer.modified_at),
            submission.task.slug,
            answer.question.id,
            answer.question.text,
            answer.value,
        ]
    )
