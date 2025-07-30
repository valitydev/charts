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
{{- if contains "-payout" .Release.Name }}
selector.cilium/group: adapters-payout
{{- else }}
selector.cilium/group: adapters
{{- end }}
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

{{/*
Build fqdn name for ingress
*/}}
{{- define "stateless.ingress.fqdn" -}}
  {{- if .ctx.Values.ingress.namespacedDomain -}}
    {{- printf "%s.%s.%s" .ctx.Values.ingress.hostPrefix .ctx.Release.Namespace .domain -}}
  {{- else -}}
    {{- printf "%s.%s" .ctx.Values.ingress.hostPrefix .domain -}}
  {{- end -}}
{{- end }}

{{/*
Build secretName for tls
*/}}
{{- define "stateless.ingress.secretName" -}}
  {{- if and .Values.ingress.tls.enabled .Values.ingress.tls.letsEncrypt.enabled -}}
    {{- printf "%s-%s" .Values.ingress.hostPrefix .Values.ingress.tls.secretName -}}
  {{- else if .Values.ingress.tls.enabled -}}
    {{- .Values.ingress.tls.secretName -}}
  {{- end -}}
{{- end }}
