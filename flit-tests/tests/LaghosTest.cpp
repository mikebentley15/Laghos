#include <flit.h>

#include <string>

template <typename T>
class LaghosTest : public flit::TestBase<T> {
public:
  LaghosTest(std::string id) : flit::TestBase<T>(std::move(id)) {}

  virtual size_t getInputsPerRun() override { return 1; }
  virtual std::vector<T> getDefaultInput() override { return { 1.0 }; }

protected:
  virtual flit::Variant run_impl(const std::vector<T> &ti) override {
    FLIT_UNUSED(ti);
    return flit::Variant();
  }

protected:
  using flit::TestBase<T>::id;
};

REGISTER_TYPE(LaghosTest)
