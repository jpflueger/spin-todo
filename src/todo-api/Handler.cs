namespace Todo.Api;

using System.Net;
using System.Text.Json;

using Fermyon.Spin.Sdk;

public static class Handler
{
    private static readonly JsonSerializerOptions DefaultSerializerOptions = new JsonSerializerOptions
    {
        PropertyNameCaseInsensitive = true,
    };

    [HttpHandler]
    public static HttpResponse HandleHttpRequest(HttpRequest request)
    {
        // accept the warmup url first
        if (request.Url == Warmup.DefaultWarmupUrl)
        {
            return new HttpResponse
            {
                StatusCode = HttpStatusCode.OK,
                Headers = new Dictionary<string, string>
                {
                    { "Content-Type", "text/plain" },
                },
                BodyAsString = "warmup",
            };
        }

        // Console.WriteLine("Logging header information");
        // foreach (var kv in request.Headers)
        // {
        //     Console.WriteLine($"\t{kv.Key}={kv.Value}");
        // }

        // only accept requests for JSON
        if (request.Headers.TryGetValue("content-type", out var contentType) && contentType is not null && contentType != "application/json")
        {
            return UnsupportedMediaType;
        }

        try
        {
            return request.Method switch
            {
                HttpMethod.Post => CreateTodo(request),
                _ => NotImplementedResponse
            };
        }
        catch (Exception e)
        {
            Console.Error.WriteLine("Exception occurred: ${0}", e);
            throw;
        }
    }

    private static HttpResponse CreateTodo(HttpRequest request)
    {
        if (request.Body.TryGetValue(out global::Buffer body))
        {
            var todoItem = JsonSerializer.Deserialize<TodoItem>(body.AsSpan(), DefaultSerializerOptions);
            if (todoItem is null)
            {
                return new HttpResponse
                {
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var connStr = SpinConfig.Get("pg_conn_str");
            var sql = "INSERT INTO todo_items (content) VALUES ($1) RETURNING id";
            var parameters = new object[] { todoItem.Text };
            var result = PostgresOutbound.Query(connStr, sql, parameters);

            if (result.Rows.Count > 0 && result.Rows[0].Count > 0 && result.Rows[0][0].Value() is int id)
            {
                todoItem.Id = id;
            }

            return new HttpResponse
            {
                StatusCode = HttpStatusCode.Created,
                BodyAsString = JsonSerializer.Serialize<TodoItem>(todoItem, DefaultSerializerOptions),
            };
        }
        else
        {
            return new HttpResponse
            {
                StatusCode = HttpStatusCode.BadRequest,
            };
        }
    }

    private static HttpResponse UnsupportedMediaType => new HttpResponse
    {
        StatusCode = HttpStatusCode.UnsupportedMediaType,
        Headers = new Dictionary<string, string>
        {
            ["Accept-Encoding"] = "application/json",
        },
    };

    private static HttpResponse NotImplementedResponse => new HttpResponse
    {
        StatusCode = HttpStatusCode.NotFound,
        Headers = new Dictionary<string, string>
        {
            ["Content-Type"] = "text/plain",
        },
        BodyAsString = $"The HTTP Method is not implemented",
    };
}