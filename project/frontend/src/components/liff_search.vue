<template>
  <div id="demo">
    <div class="btn-group fixed-buttons">
      <button :class="{ active: isAllExpense }" @click="showAllExpense">
        所有花費
      </button>
      <button :class="{ active: isPersonalExpense && !isAllExpense }" @click="showPersonalExpense">
        個人帳本
      </button>
      <button :class="{ active: !isPersonalExpense && !isAllExpense }" @click="showGroupExpense">
        群組帳本
      </button>
      <button @click="toggleCalendar" class="toggle-calendar-button">
        {{ showCalendar ? '所有時間' : '選擇日期' }}
      </button>
    </div>
    <calendar v-if="showCalendar" @change="onChange"/>
    <inlineCalendar v-if="showCalendar" @change="onChange"/>

    <div class="fixed-container">
      <div class="scrollable-block">
        <table v-if="selectedAccounts.length > 0" class="account-area">
          <thead>
            <tr>
              <th>項目</th>
              <th>日期</th>
              <th>金額</th>
              <th>類別</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(account, index) in selectedAccounts" :key="index">
              <td>{{ account.item }}</td>
              <td>{{ account.account_date }}</td>
              <td>{{ account.payment }}</td>
              <td>{{ account.category_name }}</td>
            </tr>
          </tbody>
        </table>
        <div v-else-if="loading" class="loading">載入中...</div>
        <div v-else class="account-area-placeholder"> 
          <h2>當天花費：</h2>
          <p>暫無資料</p>
        </div>
      </div>
    </div>

    <div class="bottom-buttons">
      <button @click="navigateToOverview" class="overview-button">
        帳本總覽
      </button>
      <button @click="joinGroupAccount" class="group-account-button">
        加入群組
      </button>
      <button @click="createGroupAccount" class="group-account-button">
        建立群組
      </button>
      <div class="split-button">
        <button @click="manualAccounting" class="manual-accounting">
          手動記帳
        </button>
        <button @click="voiceTextAccounting" class="voice-text-accounting">
          語音/文字記帳
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import Swal from 'sweetalert2'
export default {
  data() {
    return {
      selectedDate: '',
      accounts: [],
      isPersonalExpense: false,
      isAllExpense: true,
      loading: false,
      showCalendar: false,
      personal_id:'',
    };
  },
  methods: {
    toggleCalendar() {
      this.showCalendar = !this.showCalendar;
    },
    onChange(date) {
      const formattedDate = dayjs(date).format('YYYY-MM-DD');
      this.selectedDate = formattedDate;
    },
    fetchAccounts() {
      this.loading = true; 
      const apiUrl = `${this.$apiUrl}/api/get_personal_account/`;
      console.log(apiUrl);
      console.log(this.$root.$userId);
      this.$axios.post(apiUrl, { userId: this.$root.$userId,name: this.$root.$userName })
        .then(response => {
          console.log(response);
          this.accounts = response.data.accounts;
          this.personal_id = response.data.personal_id
        })
        .catch(error => {
          console.error(error);
        })
        .finally(() => {
          this.loading = false;
        });
    },
    showAllExpense() {
      this.isPersonalExpense = false;
      this.isAllExpense = true;
      console.log(this.personal_id)
    },
    showPersonalExpense() {
      this.isPersonalExpense = true;
      this.isAllExpense = false;
    },
    showGroupExpense() {
      this.isPersonalExpense = false;
      this.isAllExpense = false;
    },
    navigateToOverview() {
      this.$router.push({ name: 'account_overview' });
    },
    joinGroupAccount() {
    },
    createGroupAccount() {
        const { value: groupname } = Swal.fire({
          title: "輸入創建群組名稱",
          input: "text",
          confirmButtonText: '創建',
          inputPlaceholder: "請輸入",
          inputValidator: (value) => {
            if (!value) {
              return "請輸入群組名稱!";
            }else if (value.length > 200) {
              return "群組名稱不能超過200個字!";
            }
          }
        }).then((result) => {
          console.log(result)
            if(result.isConfirmed){
              const groupname = result.value;
              this.creatgroup_axios(groupname);
              Swal.fire({
                title: "創建成功!",
                icon: "success"
            });
            }
        }
      )
    },
    creatgroup_axios(groupname){
      const apiUrl = `${this.$apiUrl}/api/creategroup/`;
      this.$axios.post(apiUrl, { GroupName:groupname,userId: this.$root.$userId})
        .then(response => {
          console.log(response);
        })
        .catch(error => {
          console.error(error);
        })
        .finally(() => {
          this.loading = false;
        });
    },
    manualAccounting() {
      this.$router.push({ name: 'liff_manual_personal_form',params: {formData:this.personal_id}});
    },
    voiceTextAccounting() {
      this.$router.push({ name: 'liff_keep' });
    },
  },
  mounted() {
    const checkUserId = () => {
      if (this.$root.$userId === null) {
        console.log();
        setTimeout(checkUserId, 500); 
      } else {
        this.fetchAccounts();
      }
    };
    checkUserId();
  },
  computed: {
    selectedAccounts() {
      let filteredAccounts = this.accounts;

      if (this.selectedDate) {
        filteredAccounts = filteredAccounts.filter(account => dayjs(account.account_date).isSame(this.selectedDate, 'day'));
      }

      if (!this.isAllExpense) {
        filteredAccounts = filteredAccounts.filter(account => account.type === (this.isPersonalExpense ? 'personal' : 'group'));
      }

      return filteredAccounts;
    }
  }
};
</script>

<style scoped>
#demo {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.fixed-buttons {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: #f9f9f9;
  z-index: 1000;
  padding: 6px 0;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: center;
}

.fixed-container {
  margin-top: 70px; /* Adjust margin to make space for fixed buttons */
  height: calc(300px); 
  overflow-y: auto;
}

.scrollable-block {
  max-height: 100%; 
}

.account-area {
  border: 2px solid black; 
  padding: 10px; 
  margin: 0 auto; 
}

.account-area-placeholder {
  border: 2px solid black;
  padding: 10px; 
  opacity: 0.5; 
}

.account-area table {
  width: 100%; 
  border-collapse: collapse; 
}

.account-area th,
.account-area td {
  border: 1px solid #ddd; 
  padding: 8px; 
}

.account-area th {
  background-color: #f2f2f2;
}

.account-area tr:nth-child(even) {
  background-color: #f2f2f2; 
}

.btn-group {
  display: flex;
  justify-content: center;
  background-color:#FFEFDB;
  gap: 10px;
}

.btn-group button {
  padding: 8px 16px; 
  border: none;
  border-radius: 15px;
  background: #FFCC00; /* 深黃色背景 */
  color: black; /* 黑色字體 */
  font-size: 14px;
  cursor: pointer;
  transition: background 0.3s ease, transform 0.3s ease;
}

.btn-group button.active {
  background: #FFD700; /* 更淺的黃色 */
}

.btn-group button:hover {
  transform: scale(1.05);
}

.bottom-buttons {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background-color:#FFEFDB;
  z-index: 1000;
  padding: 10px 0;
  box-shadow: 0 -2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: center;
  gap: 10px;
  flex-wrap: wrap;
}

.bottom-buttons button {
  padding: 10px 20px; 
  border: none;
  border-radius: 20px;
  background: #FFCC00; /* 深黃色背景 */
  color: black; /* 黑色字體 */
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease, transform 0.3s ease;
}

.bottom-buttons button:hover {
  transform: scale(1.05);
}

.split-button {
  display: flex;
}

.manual-accounting {
  background: #FFCC00; /* 深黃色背景 */
  color: black; /* 黑色字體 */
  padding: 10px 20px;
  border: none;
  border-radius: 20px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease, transform 0.3s ease;
  margin-right: 10px;
}

.manual-accounting:hover {
  transform: scale(1.05);
}

.voice-text-accounting {
  background: #FFCC00; /* 深黃色背景 */
  color: black; /* 黑色字體 */
  padding: 10px 20px;
  border: none;
  border-radius: 20px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease, transform 0.3s ease;
}

.voice-text-accounting:hover {
  transform: scale(1.05);
}

.loading {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: rgba(255, 255, 255, 0.8);
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  z-index: 9999;
}

.toggle-calendar-button {
  margin-bottom: 20px;
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
  border-radius: 20px;
  background: #FFCC00; /* 深黃色背景 */
  color: black; /* 黑色字體 */
  transition: background 0.3s ease, transform 0.3s ease;
}

.toggle-calendar-button:hover {
  transform: scale(1.05);
}
</style>
