coverage:
	flutter test --no-pub --coverage && genhtml -o coverage coverage/lcov.info && open coverage/index.html