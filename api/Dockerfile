from python:3.9

WORKDIR /combyne

COPY requirements.txt /combyne/
RUN pip install -r requirements.txt

COPY *.py /combyne/

CMD ["uvicorn", "app:app", "--reload", "--host", "0.0.0.0"]