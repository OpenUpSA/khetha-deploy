```shell
../target.staging.exec.sh django-admin dumpdata --natural-foreign --natural-primary --indent 2 auth.group khetha >"khetha-staging-full-$(date -I).json"
```

Dump just the task data:

```shell
../target.staging.exec.sh django-admin dumpdata --indent 2 khetha.{task,question,answeroption} >"khetha-staging-task-data-$(date -I).json"
```

Loading (needs no `-t` to docker run?):

```shell
../target.staging.exec.sh django-admin loaddata --format=json - <fixture.json
```

Numbers:
```
../target.staging.exec.sh django-admin shell <dump-numbers.py >"phone-numbers-$(date -I).csv"
```

All answers:
```
../target.staging.exec.sh django-admin shell <dump-answers.py >"khetha-answers-$(date -I).csv"
```
