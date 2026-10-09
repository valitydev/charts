{{/* One release per tenant; everything is named sequin-<tenant>[-suffix]. */}}
{{- define "sequin.fullname" -}}
{{- printf "sequin-%s" (required "tenant is required" .Values.tenant) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "sequin.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{ include "sequin.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "sequin.selectorLabels" -}}
app.kubernetes.io/name: sequin
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/***
{{- define "sequin.statePostgresName" -}}
{{ include "sequin.fullname" . }}-state-postgres
{{- end }}

{{- define "sequin.redisName" -}}
{{ include "sequin.fullname" . }}-redis
{{- end }}
***/}}