{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "statefull.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "statefull.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "statefull.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "statefull.labels" -}}
app.kubernetes.io/name: {{ include "statefull.name" . }}
helm.sh/chart: {{ include "statefull.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
selector.cilium/release: {{ .Release.Name }}
{{- if or (hasPrefix "adapter" .Release.Name) (hasPrefix "proxy" .Release.Name) }}
selector.cilium/group: adapters
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "statefull.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "statefull.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create configs hash
*/}}
{{- define "statefull.configHash" -}}
{{ print .Values.configMap .Values.secret | sha256sum }}
{{- end -}}
