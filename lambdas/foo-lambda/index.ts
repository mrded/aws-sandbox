export const handler = async (event: any) => {
  console.log("Hello, world!");
    return {
        statusCode: 200,
        body: "OK",
    };
};
