# How to Install and Run TB-D on Terra
*If you are not using the cloud compute platform Terra, please see [this documentation](./get_started_nonTerra.md) instead. If you are unsure if you want to use Terra, try TB-D without it first.*

## Setting up your workspace
This documentation assumes you're familiar with the basics of Terra and already have a billing project set up. Terra has a great documentation website if you need more information about the system overall.

1. Import myco_raw from Dockstore
2. Import Tree Nine from Dockstore
3. [optional] Import Tree Seven and Tree Eight from Dockstore (only necessary for some metadata use cases)

## Selecting a version
Workflows from Dockstore are kept in sync with GitHub, even after you have imported the workflow. Using the dropdown menu in Terra's UI, you can select any branch or GitHub release of the workflow in question.

![terra dropdown menu version select](https://raw.githubusercontent.com/aofarrel/TB-D/refs/heads/main/find_terra_version.png)

It's recommended to use whatever the latest GitHub release is for your workflows:
* myco: https://github.com/aofarrel/myco/releases
* Tree Nine:  https://github.com/aofarrel/tree_nine/releases

Different programmers use git differently. Since I'm the sole dev, I take a pretty simple approach to things:
* Tagged commits/GitHub releases are technically mutable, but as a general rule I don't mess with them once I make them.
* If I'm making hotfixes, I work directly on the main branch.
* If I'm adding a feature or doing an important overhaul, that work is done on a feature branch. Once I've confirmed it works properly on Terra, I open a PR and pull it into main, and then make a release.
* I have precommit hooks myco repos to catch WDL errors, but due to the nature of dependencies or quirks specific to womtool bugs occasionally slip through. Tree Nine runs pylint on cluster-related scripts, although it's set up mostly to catch syntax errors rather than make things pretty.
