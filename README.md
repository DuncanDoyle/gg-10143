# Gloo-10143 Reproducer

Issue: https://github.com/solo-io/gloo/issues/10143

## Installation

Add Gloo EE Helm repo:
```
helm repo add glooe https://storage.googleapis.com/gloo-ee-helm
```

Export your Gloo Gateway License Key to an environment variable:
```
export GLOO_GATEWAY_LICENSE_KEY={your license key}
```

Install Gloo Gateway:
```
cd install
./install-gloo-gateway-with-helm.sh
```

> NOTE
> The Gloo Gateway version that will be installed is set in a variable at the top of the `install/install-gloo-gateway-with-helm.sh` installation script.

## Setup the environment

Run the `install/setup.sh` script to setup the environment:

- Deploy the HTTPBin application
- Deploy the AuthConfig
- Deploy the VirtualServices

```
./setup.sh
```

## Deploy the secret

Deploy the secret that causes the issue:

```
kubectl apply -f secrets/mysecret.yaml
```

The Gloo controller pod now will log the following `dpanic`:

```
{"level":"dpanic","ts":"2024-10-03T18:16:04.097Z","caller":"translator/translator.go:348","msg":"marshalling envoy snapshot components: string field contains invalid UTF-8","stacktrace":"github.com/solo- │
│ io/gloo/projects/gloo/pkg/translator.EnvoyCacheResourcesListToFnvHash\n\t/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/translator/translator.go:348\ngithub.com/solo-io/solo-projects/proje │
│ cts/gloo/pkg/syncer/extauth.(*translatorSyncerExtension).Sync\n\t/go/src/github.com/solo-io/solo-projects/projects/gloo/pkg/syncer/extauth/extauth_translator_syncer.go:109\ngithub.com/solo-io/gloo/projec │
│ ts/gloo/pkg/syncer.(*translatorSyncer).syncExtensions\n\t/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/syncer/translator_syncer.go:165\ngithub.com/solo-io/gloo/projects/gloo/pkg/syncer.(* │
│ translatorSyncer).Sync\n\t/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/syncer/translator_syncer.go:139\ngithub.com/solo-io/gloo/projects/gloo/pkg/api/v1/gloosnapshot.ApiSyncers.Sync\n\t/ │
│ go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/api/v1/gloosnapshot/api_event_loop.sk.go:50\ngithub.com/solo-io/gloo/projects/gloo/pkg/api/v1/gloosnapshot.(*apiEventLoop).Run.func1\n\t/go/pk │
│ g/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/api/v1/gloosnapshot/api_event_loop.sk.go:107"}                                                                                                      │
│ {"level":"dpanic","ts":"2024-10-03T18:16:04.098Z","logger":"gloo-ee.v1.event_loop.setup.gloosnapshot.event_loop.extAuthTranslatorSyncer","caller":"extauth/extauth_translator_syncer.go:111","msg":"error t │
│ rying to hash snapshot resources for extauth translation","version":"1.17.1","error":"marshalling envoy snapshot components: string field contains invalid UTF-8","errorVerbose":"marshalling envoy snapsho │
│ t components\n\tgloosnapshot.ApiSyncers.Sync:/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/api/v1/gloosnapshot/api_event_loop.sk.go:50\n\tsyncer.(*translatorSyncer).Sync:/go/pkg/mod/githu │
│ b.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/syncer/translator_syncer.go:139\n\tsyncer.(*translatorSyncer).syncExtensions:/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/syncer/translator_s │
│ yncer.go:165\n\textauth.(*translatorSyncerExtension).Sync:/go/src/github.com/solo-io/solo-projects/projects/gloo/pkg/syncer/extauth/extauth_translator_syncer.go:109\n\ttranslator.EnvoyCacheResourcesListT │
│ oFnvHash:/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/translator/translator.go:349\nstring field contains invalid UTF-8","stacktrace":"github.com/solo-io/solo-projects/projects/gloo/pkg/ │
│ syncer/extauth.(*translatorSyncerExtension).Sync\n\t/go/src/github.com/solo-io/solo-projects/projects/gloo/pkg/syncer/extauth/extauth_translator_syncer.go:111\ngithub.com/solo-io/gloo/projects/gloo/pkg/s │
│ yncer.(*translatorSyncer).syncExtensions\n\t/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/syncer/translator_syncer.go:165\ngithub.com/solo-io/gloo/projects/gloo/pkg/syncer.(*translatorSyn │
│ cer).Sync\n\t/go/pkg/mod/github.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/syncer/translator_syncer.go:139\ngithub.com/solo-io/gloo/projects/gloo/pkg/api/v1/gloosnapshot.ApiSyncers.Sync\n\t/go/pkg/mod/gi │
│ thub.com/solo-io/gloo@v1.17.4/projects/gloo/pkg/api/v1/gloosnapshot/api_event_loop.sk.go:50\ngithub.com/solo-io/gloo/projects/gloo/pkg/api/v1/gloosnapshot.(*apiEventLoop).Run.func1\n\t/go/pkg/mod/github. │
│ com/solo-io/gloo@v1.17.4/projects/gloo/pkg/api/v1/gloosnapshot/api_event_loop.sk.go:107"}
```