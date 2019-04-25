#   -Build an image starting with the Python 3.4 image.
#   -Add the current directory . into the path /code in the image.
#   -Set the working directory to /code.
#   -Install the Python dependencies.
#   -Set the default command for the container to python app.py.
#
FROM continuumio/anaconda3
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]

FROM centos
RUN yum check-update -y
RUN yum upgrade -y
