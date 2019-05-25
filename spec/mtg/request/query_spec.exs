defmodule Mtg.Request.QuerySpec do
  use ESpec

  it "creates no params" do
    expect Mtg.Request.Query.build_path("/endpoint", []) |> to(eq "/endpoint")
  end

  context "when having one simple parameter" do
    let :query_params, do: [{:name, "Abundance"}]

    it "adds one param" do
      expect Mtg.Request.Query.build_path("/endpoint", query_params())
      |> to(eq "/endpoint?name=Abundance")
    end
  end

  context "when searching by OR operator" do
    let :query_params, do: [{:name, :or, ["Abundance", "Tarmogoyf"]}]

    it "adds one param" do
      expect Mtg.Request.Query.build_path("/endpoint", query_params())
      |> to(eq "/endpoint?name=Abundance|Tarmogoyf")
    end
  end

  context "when searching by OR operator" do
    let :query_params, do: [{:name, :and, ["Abundance", "Tarmogoyf"]}]

    it "adds one param" do
      expect Mtg.Request.Query.build_path("/endpoint", query_params())
      |> to(eq "/endpoint?name=Abundance,Tarmogoyf")
    end
  end
end
