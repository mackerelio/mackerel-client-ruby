RELEASE
=======

1. Create release branch. (`git checkout -b version-<VERSION>`)
1. Bump version `VERSION` and `lib/mackerel/version.rb` files.
1. Push release branch to upstream(GitHub). (`git push -u origin version-<VERSION>`)
1. Create Pull-Request on Github.
1. Merge Pull-Request to master branch on Github.
1. Tagging and Release. (`rake release`)
