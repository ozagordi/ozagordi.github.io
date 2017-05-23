## ozagordi.github.io

Using Clean Blog theme by [Start Bootstrap](http://startbootstrap.com/).

### Building and deploying `_site` to GitHub Pages

The site is built locally with jekyll because it relies on some gems not
provided by GitHub Pages. The entire `_site` directory

The source is in the `gh-pages` branch, the site is built locally with jekyll
because it relies on some gems not provided by GitHub Pages. Once built,
the `_site` directory is copied into the master branch. This is achieved by
pushing `_site` in a subtree on the master branch as explained
[here](https://gist.github.com/cobyism/4730490) by switching `master` with
`gh-pages`. The commands are

    git checkout gh-pages
    # here update the source, build with R, do whatever and build/test with
    # `jekyll serve`
    git add ...  # add files in _site as well
    git commit -m "commit message"
    git push
    git subtree push --prefix _site origin master

### Other solutions?

Check [this tutorial](http://blog.blindgaenger.net/generate_github_pages_in_a_submodule.html) using submodules instead.
