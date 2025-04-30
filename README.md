# Задание

**Цель**: Продемонстрировать работу с Kubernetes

**Задача**:

1. Создать минимальный сервис, который отвечает на порту 8000 и имеет http-метод GET /health/ RESPONSE: {"status": "OK"}

2. Cобрать локально образ приложения в докер. Запушить образ в dockerhub

3. Написать манифесты для деплоя в k8s для этого сервиса, а именно:
   - Манифесты должны описывать сущности: Deployment, Service, Ingress.
   - В Deployment могут быть указаны Liveness, Readiness пробы.
   - Количество реплик должно быть не меньше 2.
   - Image контейнера должен быть указан с Dockerhub.
   - Хост в ингрессе должен быть arch.homework. В итоге после применения манифестов GET запрос на http://arch.homework/health должен отдавать {“status”: “OK”}.

### На выходе предоставить

1. Ссылку на github c манифестами. Манифесты должны лежать в одной директории, так чтобы можно было их все применить одной командой kubectl apply -f .
2. Endpoint, по которому можно будет получить ответ от сервиса (либо тест в postman).
3. В Ingress должно быть правило, которое форвардит все запросы с /otusapp/{name}/* на сервис с rewrite-ом пути. Где {name} - это имя того, кто выполняет задание.

------------

### Результат

1. [Манифесты][1]
2. [Deployment с Probs][2]
3. Количество реплик и image containers с dockerhub [Реплики+Image][3]
4. Хост в Ingress [Ingress][4]

#### Порядок запуска проекта

**Клонировать проект в локальный репозиторий**

 ```
 git clone https://github.com/Jony2Good/k8s_basics.git
```
 - в корневой директории найти файл .env.example исправить его на .env

**Стартуем minikube**
```
minikube start
```
**Инициализируем манифесты**

```
kubectl apply -f k8s/
```
------------
<span style="color: red;">Важно!!! Все pods находятся под namespace <span style="color: green">k8s-basics</span></span>

------------

**Проверяем pods**
```
kubectl get pods -n k8s-basics
```
***Проверяем Ingress (его не будет, далее установим)***
```
kubectl get ingress -n k8s-basics
```
ПРЕЖДЕ ВСЕГО НУЖЕН РЕПОЗИТОРИЙ HELM (скачиваем)
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```
Устанавливаем ingress-controller в namespase k8s-basics
```
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace k8s-basics
```
Проверяем
```
kubectl get svc -n k8s-basics
```
Должна появится таблица. Нас интересует только ingress-nginx-controller. У него должен быть *Type:LoadBalanser* и *External-IP:pending*

| NAME                    | TYPE         | CLUSTER-IP     | EXTERNAL-IP    | PORT(S)                    | AGE |
| ----------------------- | ------------ | -------------- | -------------- | -------------------------- | --- |
| ngress-nginx-controller | LoadBalancer | 10.104.118.219 |  pending  | 80:31047/TCP,443:31617/TCP | 95m |

Нам необходимо, чтобы домен arch.homework открывался без порта и по специальному url. Для этого мы должны прописать команду:
```
minikube tunnel
```

Далее снова смотрим в таблицу на значение в колонке **EXTERNAL-IP** (вместо pending должно появится значение, к примеру, 10.107.105.245) в ней должен прописаться внешний IP-адрес.

Копируем данный внешний адрес и прописываем в файле hosts машины правило маршрутизации, где развернут кластер:

```
10.107.105.245 arch.homework
```
Справка: для ОС windows прописываем в файле и сохраняем:
```
C:\Windows\System32\drivers\etc\hosts
```

### В браузере вводим следующи url:
http://arch.homework/otusapp/aemelyanenko

Endpoints (особенности Laravel приложения):
- /health будет доступна на маршруте: http://arch.homework/otusapp/aemelyanenko/api/health
- /ready будет доступна на маршруте: http://arch.homework/otusapp/aemelyanenko/api/ready

[1]: https://github.com/Jony2Good/k8s_basics/tree/main/k8s "Манифесты"
[2]: https://github.com/Jony2Good/k8s_basics/blob/main/k8s/09-nginx-deployment.yaml "Deployment с Probs"
[3]: https://github.com/Jony2Good/k8s_basics/blob/main/k8s/06-php-deployment.yaml "Реплики+Image"
[4]: https://github.com/Jony2Good/k8s_basics/blob/main/k8s/11-app-ingress.yaml "Ingress"
