using Todo.Api;

namespace Todo.UnitTests;

public class TodoItemFixture
{
    [Fact]
    public void GivenValues_Constructs_WithoutError()
    {
        var todoItem = new TodoItem
        {
            Id = 1,
            Content = "Some content"
        };
        Assert.True(true);
    }

    [Fact]
    public void GivenEmpty_Constructs_WithoutError()
    {
        var todoItem = new TodoItem();
        Assert.True(true);
    }
}