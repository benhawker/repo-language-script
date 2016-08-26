### CLI Github User Language Search

===================

### Usage:

In irb console:
```
require_relative 'lib/client'

Client.new('a_github_user').favorite
```

As Command Line application:
```
ruby bin/favorite benhawker
```

### Expected response:

```
"User X's favorite language seems to be Ruby and Go."
```

===================