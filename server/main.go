// Command spxdev-plugin-hello is the backend half of this spxdev plugin.
// It implements pluginsdk.Plugin (see plugin.go) and is spawned by spxdev as
// a gRPC subprocess — there is no HTTP server, no listen address, and no
// secrets to configure: pluginsdk.Serve owns the entire transport.
//
// To make this your own, rename `templatePlugin` in plugin.go (and keep the
// id in manifest.yaml, go.mod's module line, and ui/bundle.js in sync).
package main

import "github.com/phongdoanthanh/spxdev/pkg/pluginsdk"

func main() {
	pluginsdk.Serve(&templatePlugin{})
}
