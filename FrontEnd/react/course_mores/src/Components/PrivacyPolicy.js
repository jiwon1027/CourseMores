const PrivacyPolicy = () => {
  const iframePart = () => {
    return {
      __html:
        '<iframe src="/privacy.html" width="100%" height="1000px"></iframe>',
    };
  };

  return (
    <div
      style={{
        margin: "auto",
        position: "relative",
        width: "100%",
        height: "100%",
        overflow: "hidden",
      }}
      dangerouslySetInnerHTML={iframePart()}
    />
  );
};

export default PrivacyPolicy;
