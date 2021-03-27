{{/*
Expand the name of the chart.
*/}}
{{- define "ssl-slert.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ssl-slert.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ssl-slert.labels" -}}
helm.sh/chart: {{ include "ssl-slert.chart" . }}
{{ include "ssl-slert.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ssl-slert.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ssl-slert.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
