start:
	elm-live src/Main.elm --open --pushstate --start-page=src/index.html -- --output=elm.js

deploy:
	bash gh-pages.sh
