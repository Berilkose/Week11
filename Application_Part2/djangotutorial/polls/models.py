import datetime
from django.db import models
from django.utils import timezone

#Question ve Choice adında iki tane tablo modeli oluşturduk.

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField("date published")
    def __str__(self):
        return self.question_text
    
    #global serverdeki zaman ile karşılaştırarak, sorunun son 24 saat içinde yayınlanıp yayınlanmadığını kontrol eder.
    #global serverlarda oluşabilecek zaman karmaşalarını çözer.
    def was_published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)


class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __str__(self):
        return self.choice_text