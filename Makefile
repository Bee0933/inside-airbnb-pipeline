install:
	# install dependencies
	pip install --upgrade pip &&\
		pip --default-timeout=1000 install -r requirements.txt 
format:
	# format python code with black
	black flows/blocks/*.py 
lint:
	# check code syntaxes
	pylint --disable=R,C flows/blocks/*.py 


# CI process
all: install format lint 