# Instana OSGi Feature Resource

Deploys and retrieves artifact versions as determined by an OSGi features.xml from an artifact repository.

To define such resource for a Concourse pipeline:

``` yaml
resource_types:

- name: osgi-feature-resource
  type: registry-image
  source:
    repository: icr.io/instana/osgi-feature-resource
    tag: latest

resources:

  - name: instana-java-tracer
    type: osgi-feature-resource
    source:
      download_key: ((instana-download-key))
      feature_group: com.instana
      feature_artifact: sensor-feature
      feature_name: instana-java-trace-sensor
      file_name: sensor-java-trace-:version.jar
```

## Source Configuration

* `artifactory_root_url_features`: The artifact repository root URL for downloading the features.xml file (default: `https://artifact-public.instana.io/artifactory/features-public`)
* `artifactory_root_url_artifacts`: The artifact repository root URL for downloading the actual artifacts (default: `https://artifact-public.instana.io/artifactory/shared`)
* `feature_group`: The Maven group for the features.xml file (not the group of the artifact!) ()default: `com.instana`).
* `feature_artifact`: The name of the features.xml file artifact (not the name of the artifact!) (default: `sensor-feature`).
* `feature_name`: *Required* The name of the feature, that is, the value of the `name` attribute of the `feature` tag in the features.xml file.
* `file_name`: *Required* The file name/pattern of the artifact to download. Use the token `:version` as a placeholder for the version. This field can be omitted if `params.skip_download` is `true`, otherwise it is required.
* `username`: The user name for authentication with the artifact repository (default: `_`)
* `download_key`: *Required* A valid Instana download key.
* `skip_ssl_verification`: *Optional* Does not perform SSL verification; default: perform SSL verification.

## Resource behavior

### `check`

Retrieves the latest version of the configured feature.

* Retrieves the `maven-metadata.xml` file from the configured `features.xml` artifact.
* Downloads the `features.xml` file that the `maven-metadata.xml` file refers to.
* Searches the `features.xml` file for a `feature` tag with the name provided via `feature_name`.
* Returns the `version` of that feature.

### `in`

Retrieves version of the artifact that has been determind in the `check` step.

The following files will be placed in the destination:

* `/version`: A text file containing the version of the artifact (say, `1.2.434`).
* `/metadata.json`: A file with the following format: `{"file_name":"sensor-java-trace-1.2.434.jar","etag":"fc65c4e1af8f11ef500f3bd99d6951ffac41ca243b6cb7fe01897ad07dc38d65","group":"com.instana","artifact":"sensor-java-trace","version":"1.2.434"}`. The values `file_name` and `etag` will be missing if the parameter `skip_download` is `true`.
* `/${artifact}`: The artifact that has been downloaded from the artifact repository. The file name will be in the form provided via the `source.file_name` parameter. The concrete filename is also available in `/metadata.json`. This file will no be present if the parameter `skip_download` is `true`.

#### Parameters

* `skip_download`: Optional. Skip downloading the actual artifact. Useful if you only want to trigger a job when a new release is available.

### `out`

The `out` script is not implemented, this resource is read-only.

## Development

### Build Docker image

Run the following command in the root folder:

```sh
docker build -t icr.io/instana/osgi-feature-resource .
```

### Tests

The wrapper scripts in tests are available to test the resource locally in an ad-hoc/manual way, outside of Concourse. There are no automated tests.

### Publish to Image Registry

```sh
docker tag icr.io/instana/osgi-feature-resource <your-image-repository-here>/osgi-feature-resource:latest
docker push <your-image-repository-here>/osgi-feature-resource:latest
```

## Related Resources

Take a look at https://github.com/instana/artifactory-resource if you are looking for a simpler resource that just downloads artifacts from an artifact repository, without consulting an OSGi `features.xml` file beforehand.
