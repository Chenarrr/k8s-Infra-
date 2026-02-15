{{/*
Chart name, truncated to 63 chars.
*/}}
{{- define "notes-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Fully qualified app name, truncated to 63 chars.
*/}}
{{- define "notes-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "notes-app.name" . -}}
{{- end -}}
{{- end -}}

{{/*
Chart label value.
*/}}
{{- define "notes-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels shared by all resources.
*/}}
{{- define "notes-app.labels" -}}
helm.sh/chart: {{ include "notes-app.chart" . }}
app.kubernetes.io/part-of: {{ include "notes-app.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/* ---- Backend ---- */}}

{{- define "notes-app.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.backend.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "notes-app.backend.labels" -}}
{{ include "notes-app.labels" . }}
{{ include "notes-app.backend.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end -}}

{{/* ---- Frontend ---- */}}

{{- define "notes-app.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.frontend.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "notes-app.frontend.labels" -}}
{{ include "notes-app.labels" . }}
{{ include "notes-app.frontend.selectorLabels" . }}
app.kubernetes.io/component: web
{{- end -}}

{{/* ---- MongoDB ---- */}}

{{- define "notes-app.mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.mongodb.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "notes-app.mongodb.labels" -}}
{{ include "notes-app.labels" . }}
{{ include "notes-app.mongodb.selectorLabels" . }}
app.kubernetes.io/component: database
{{- end -}}

{{/* ---- Ingress ---- */}}

{{- define "notes-app.ingress.labels" -}}
{{ include "notes-app.labels" . }}
{{- end -}}
