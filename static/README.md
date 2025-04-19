# static: a static web server with very basic auto-reload functionality

Scenario: you're doing some front-end web development with entirely static
resources, but you're using javascript modules.  You must therefore serve
your content over http, so you need the world's simplest static web server.

As a bonus, when you save any file, you want the browser to automatically
reload the whole page so you can see your changes in action.

## Usage

```bash
$ static
```

Starts an http server on port 8080, serving the content in the local directory.

Requests to `/_events` respond with 
[server-sent events](https://en.wikipedia.org/wiki/Server-sent_events)
whenever any file changes.

To make use of this, embed the following snippet into your html:
```html
<script type="text/javascript">
    const src = new EventSource("/_events");
    src.onmessage = event => {
        console.log(event);
        window.location.reload();
    };
</script>
```
## Inspiration

Inspired by Baldur Bjarnasson's [Uncluttered](https://www.baldurbjarnason.com/courses/uncluttered/).

This can be a more interactive version of his [mocha test setup](https://github.com/baldurbjarnason/uncluttered-mocha-setup).
